Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab2DJO6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:58:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758956Ab2DJO6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:58:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.4-rc2-rt1
Date: Tue, 10 Apr 2012 14:58:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <alpine.LFD.2.02.1204101642050.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1204101642050.2542@ionos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204101458.20026.arnd@arndb.de>
X-Provags-ID: V02:K0:YbXE1fl9idx61fJ/AXN95J5IO3kfbABSfDd6wPs8Knc
 jCvlrTC8rOaLqH2xREQCPXjfGeyUcvIemBExqDNtssl/dRIgy6
 qcXdU1i/d/ww+n4Bbs7U6q70oNBdKfl5ofq+OWa1COwO3yT4E4
 kJIJKLxNoPhRm6phif6yGSP8DH2zvCpyODzvKdqfB0zoIPYflM
 HZ70RPzmM5v/pT7NJNFX08tGxBS73xoGI2z77zQvtUOquFtsPe
 CkbnriqyrEArnKw9Tm3+OueRyb8WjQnrmNposSdy2mTXKs5Bgy
 XUFU6O521MfrlO7apRvAqn6JvrAIzTCiia2oqpY1tNH/Wt33Na
 BhlT/UfOdMNCMl4NS5CM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2012, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.4-rc2-rt1 release.
> 
> This is a straight forward update of the 3.2 series to 3.4-rc2. It's
> slightly smaller than the 3.2 series. I hope to stabilize it fast so I
> can concentrate on shuffling more parts of RT into 3.5.
> 
> The RT patch against 3.4-rc2-rt1 can be found here:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4-rc2-rt1.patch.xz
> 
> 
> The split quilt queue is available at:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patches-3.4-rc2-rt1.tar.xz
> 
> Enjoy,
> 
> 	tglx
> ---
> Index: linux-3.2/fs/autofs4/autofs_i.h
> ===================================================================
> --- linux-3.2.orig/fs/autofs4/autofs_i.h
> +++ linux-3.2/fs/autofs4/autofs_i.h

I guess the patch you attached here with this diffstat

 block/blk-iopoll.c      |    3 +++
 block/blk-softirq.c     |    3 +++
 fs/autofs4/autofs_i.h   |    1 +
 fs/autofs4/expire.c     |    2 +-
 fs/dcache.c             |    7 ++++---
 fs/namespace.c          |    3 ++-
 include/linux/delay.h   |    6 ++++++
 include/linux/preempt.h |    2 ++
 kernel/irq/manage.c     |   44 ++++++++++++++++++++++++++++++++++++++------
 localversion-rt         |    2 +-
 net/core/dev.c          |    6 ++++++
 net/packet/af_packet.c  |    5 +++--
 net/rds/ib_rdma.c       |    3 ++-
 13 files changed, 72 insertions(+), 15 deletions(-)

is not the one you describe above but the one for the 3.2.14-rt24 release,
right? Otherwise it would be considerably smaller compared to 3.2-rt, not
just a bit ;-)

	Arnd
