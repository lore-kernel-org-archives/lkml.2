Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab1CYVrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:47:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:36706 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab1CYVrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:47:21 -0400
Date: Fri, 25 Mar 2011 22:47:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [patch 2/2] bfin: Convert irq namespace
In-Reply-To: <AANLkTinsfJVF0wFiyZ=D=nM6gGVnpA8h9SyeoSRcnyqm@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103252246040.31464@localhost6.localdomain6>
References: <20110325133039.521553268@linutronix.de> <20110325133203.039794496@linutronix.de> <AANLkTinmwi8qa2_OFWz7o2sJoa04cK8Kod0QvpwvcBgm@mail.gmail.com> <AANLkTinsfJVF0wFiyZ=D=nM6gGVnpA8h9SyeoSRcnyqm@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1553556381-1301089639=:31464"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1553556381-1301089639=:31464
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Fri, 25 Mar 2011, Mike Frysinger wrote:

> On Fri, Mar 25, 2011 at 17:34, Mike Frysinger wrote:
> > On Fri, Mar 25, 2011 at 09:32, Thomas Gleixner wrote:
> >> -       __set_irq_handler_unlocked(irq, handle);
> >> +       __irq_set_handler_locked(irq, handle);
> >
> > looks like a typo in your patch ?  should still be unlocked right ?
> 
> although that still doesnt fix the build failure for me ...
> 
> arch/blackfin/mach-common/ints-priority.c: In function ‘bfin_set_irq_handler’:
> arch/blackfin/mach-common/ints-priority.c:562: error: implicit
> declaration of function ‘__irq_set_handler_unlocked’

Sorry the patch is correct, but it depends on a pending pull
request. I hope that hits linus tree tonight.

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/urgent

Thanks,

	tglx


---1463795968-1553556381-1301089639=:31464--
