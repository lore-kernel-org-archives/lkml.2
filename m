Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab1F2TbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 15:31:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40971 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab1F2TbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 15:31:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Starr <shawn.starr@rogers.com>
Subject: Re: [Bug #37232] [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) for reason a1 on CPU 0
Date: Wed, 29 Jun 2011 21:32:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <XWjMN7gBoXK.A.MrD.8Z6BOB@chimera> <2202361.0SXGgnGr4r@segfault.sh0n.net>
In-Reply-To: <2202361.0SXGgnGr4r@segfault.sh0n.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106292132.12265.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 28, 2011, Shawn Starr wrote:
> On Sunday, June 26, 2011 11:23:44 PM Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.39.  Please verify if it still should be listed and let the
> > tracking team know (either way).
> > 
> This continues in -rc4, although Fedora has a patch to try to fix some DMAR 
> errors, it doesn't seem to work for me.
> 
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] 
> Network Connection
> 
> [ 1046.002195] DMAR:[DMA Write] Request device [03:00.0] fault addr ffda6000 
> [ 1046.002198] DMAR:[fault reason 05] PTE Write access is not set
> [ 1048.189224] DRHD: handling fault status reg 2
> [ 1048.189240] DMAR:[DMA Write] Request device [03:00.0] fault addr ffd94000 
> [ 1048.189244] DMAR:[fault reason 05] PTE Write access is not set
> 
> $ uname -a
> Linux segfault.sh0n.net 3.0-0.rc4.git0.2.fc16.x86_64 #1 SMP Wed Jun 22 
> 16:27:16 UTC 2011 x86_64 x86_64 x
> 
> Perhaps someone from Intel can comment on why this broke recently? It's not 
> causing me issues, just noise in logs/dmesg.
> 
>
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37232
> > Subject		: [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) 
> for
> > reason a1 on CPU 0 Submitter	: Shawn Starr <shawn.starr@rogers.com>
> > Date		: 2011-06-03 4:56 (24 days old)
> > Message-ID	: <4478124.OuFNgaPiHS@segfault.sh0n.net>
> > References	: http://marc.info/?l=linux-kernel&m=130707737616116&w=2

Thanks for the update.

Rafael
