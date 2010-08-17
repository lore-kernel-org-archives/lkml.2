Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab0HQKgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:36:05 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:20602 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0HQKgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:36:03 -0400
X-SpamScore: -40
X-BigFish: VPS-40(zzbb2dK1432N9370J98dN179dN9371Pzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7AL54-02-F2Z-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Tue, 17 Aug 2010 12:29:28 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-22-generic; KDE/4.4.2; x86_64; ; )
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008171132.56431.stephan.diestelhorst@amd.com> <4C6A6145.7020707@gmail.com>
In-Reply-To: <4C6A6145.7020707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-ID: <201008171229.28917.stephan.diestelhorst@amd.com>
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 17 August 2010 12:15:33 Tejun Heo wrote:
> On 08/17/2010 11:32 AM, Stephan Diestelhorst wrote:
> > Indeed. Like I said, I have similar issues on a another Samsung HDD in
> > an AMD system. I have not yet got around to try the fix there, but I
> > suspect it is the same thing.
> > 
> > I have attached the full /var/log/messages and /var/log/kern.log with
> > multiple suspend-to-ram runs and the last one failing.
> 
> Hmm... are you sure the patch is applied?  There's no debug message
> outputs in the log which the patch added.

...

Let me get back to you. :-/

Stephan

-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

