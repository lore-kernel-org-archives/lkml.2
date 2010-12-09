Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0LII05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 03:26:57 -0500
Received: from smtp.duncanthrax.net ([89.31.1.170]:45006 "EHLO
	smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab0LII0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 03:26:55 -0500
From: svens@stackframe.org
To: hans-christian.egtvedt@atmel.com
Cc: linux-kernel@vger.kernel.org, svens@stackframe.org
Subject: [Patch v2] AVR32: fix sys_execve build breakage
Date: Thu,  9 Dec 2010 09:26:40 +0100
Message-Id: <1291883201-7903-1-git-send-email-svens@stackframe.org>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291874601.2794.5.camel@hcegtvedt>
References: <1291874601.2794.5.camel@hcegtvedt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > commit d7627467b7a8dd6944885290a03a07ceb28c10eb change sys_execve()
> > arch/avr32, but the version in syscalls.h is still the old one.
> >
> > Signed-off-by: Sven Schnelle <svens@stackframe.org>
> > ---
> >  arch/avr32/include/asm/syscalls.h |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/avr32/include/asm/syscalls.h b/arch/avr32/include/asm/syscalls.h
> > index ab608b7..dd69aa0 100644
> > --- a/arch/avr32/include/asm/syscalls.h
> > +++ b/arch/avr32/include/asm/syscalls.h
> > @@ -24,6 +24,11 @@ asmlinkage int sys_vfork(struct pt_regs *);
> >  asmlinkage int sys_execve(const char __user *, char __user *__user *,
> >  			  char __user *__user *, struct pt_regs *);
> >
> > +asmlinkage int sys_execve(const char __user *ufilename,
>
> Invalid patch, double definition of sys_execve.

This should be the right one. Stupid me.

