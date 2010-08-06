Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203Ab0HFGsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 02:48:01 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:46505 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0HFGr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 02:47:58 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz9370J98dN936eM4015Lzz1202hzz15d4Rz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L6PWRL-01-G2Z-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Fri, 6 Aug 2010 08:30:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-24-generic; KDE/4.4.5; x86_64; ; )
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C52DF50.80009@kernel.org> <4C5AE1E2.6070601@gmail.com>
In-Reply-To: <4C5AE1E2.6070601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-ID: <201008060830.50889.stephan.diestelhorst@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Thursday 05 August 2010, 18:08:02 Tejun Heo wrote:
> Can you please try the following patch and see whether the problem
> goes away?
<snip>

to which revision does the patch apply? I didn't get it to apply
cleanly to Linus' kernel HEAD or the 2.6.34 stable tag. Maybe I am
missing something, since I am a git-n00b (use Mercurial all the time)?

Thanks,
  Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

