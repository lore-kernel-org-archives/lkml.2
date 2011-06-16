Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1FPUW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:22:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab1FPUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:22:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 5/5] kgdbts: unify/generalize gdb breakpoint adjustment
Date: Thu, 16 Jun 2011 22:21:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sh@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org> <BANLkTi=iKW+XsfSBoPJmZWZOvq4RKa_Yjg@mail.gmail.com> <BANLkTim5fBUmyH-Vo+6zSgoZdXxu-Mq6OA@mail.gmail.com>
In-Reply-To: <BANLkTim5fBUmyH-Vo+6zSgoZdXxu-Mq6OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106162221.53360.arnd@arndb.de>
X-Provags-ID: V02:K0:kmqM0/1dEMcacEqp/7+BAuVVDcef71Fmac499/BzEJU
 o8xDqYDuzSimgJyK1HRaV4dhPPFWkuardDjMkJBlBn8f2jFWvM
 wjK+6X3DogmIJcxnO8aqGNm1gXm4bLZw9eZrUwx05ZXXMLXCZt
 no3AQIp7bqLvRotZm5ohoxTjMtUdp/4D5eR7s7TVbl47bHPfvA
 tTTx88k+ZoD1kt18hSguw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011 22:07:55 Mike Frysinger wrote:
> On Thu, Jun 16, 2011 at 16:06, Mike Frysinger wrote:
> > On Thu, Jun 16, 2011 at 11:07, Arnd Bergmann wrote:
> >> This patch is causing build problems now, because the instruction_pointer_set()
> >> that is used now is only defined in asm-generic/ptrace.h, which is only
> >> used on x86, blackfin and sparc. Every other architecture now fails to
> >> build.
> >
> > a fix was already merged over two weeks ago.  so either your tree is
> > out of date,
> >
> > your tree is out of date.
> 
> blah, network died before i could finish editing this
> 
> your tree is out of date or you're seeing a different issue and need
> to post a full build log

Ok, sorry for the noise. I've only now completed going through the build
errors of ARM randconfig on -rc1 and obviously need to rebase my fixes.

	Arnd
