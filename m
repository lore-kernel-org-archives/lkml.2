Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0IBOhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:37:13 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:57229 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab0IBOhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:37:11 -0400
X-SpamScore: -31
X-BigFish: VPS-31(zz146fK1432N1a09M9370J98dNzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L84J1C-02-33G-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Thu, 2 Sep 2010 16:31:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35pmfix-rafael-v2+; KDE/4.5.0; x86_64; ; )
CC: Tejun Heo <htejun@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008262024.35551.rjw@sisk.pl> <201008280135.39005.rjw@sisk.pl>
In-Reply-To: <201008280135.39005.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <201009021632.00699.stephan.diestelhorst@amd.com>
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 August 2010, 01:35:38 Rafael J. Wysocki wrote:
> I reproduced the problem with the Tejun's patch applied, so I'm now quite
> sure the problem is related to the suspend of controller ports (which is done
> by scheduling SCSI error handling on the controller).
> 
> Anyway, below is a new version of my patch that plays a bit nicer with
> the resume code.  Can you please check if it still fixes the problem for you?

Applied to 2.6.35.3 and tested. Works perfectly fine (> 10 s2ram
cycles under heavy I/O load).

Many thanks,
  Stephan

-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

