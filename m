Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1FPUGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:06:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50122 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab1FPUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=p+fI+MkWvb6heWoC7y0Sjq1W+dHBN+yUYSXH10mYaXivD5dfm2cuAYBYPE71460Vop
         1SBQhVimIKmJOV+HbsQPXP6Kkw6xH/P1311zeTBQshDhLO/iznl5HwiY7ipcUBOBQOMy
         jEK5JRd6jxqkXOVTfVxQ7Xew9wMtrw3NExwls=
MIME-Version: 1.0
In-Reply-To: <201106161707.32356.arnd@arndb.de>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
 <1302760895-13459-6-git-send-email-vapier@gentoo.org> <20110418082900.GB32457@linux-sh.org>
 <201106161707.32356.arnd@arndb.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 16 Jun 2011 16:06:09 -0400
X-Google-Sender-Auth: DAsgFzPSM_Z_X8v4EUlvpJnTyHE
Message-ID: <BANLkTi=iKW+XsfSBoPJmZWZOvq4RKa_Yjg@mail.gmail.com>
Subject: Re: [PATCH 5/5] kgdbts: unify/generalize gdb breakpoint adjustment
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mundt <lethal@linux-sh.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sh@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 11:07, Arnd Bergmann wrote:
> This patch is causing build problems now, because the instruction_pointer_set()
> that is used now is only defined in asm-generic/ptrace.h, which is only
> used on x86, blackfin and sparc. Every other architecture now fails to
> build.

a fix was already merged over two weeks ago.  so either your tree is
out of date,

your tree is out of date.

you also need a little qualification there ... every arch *which
supports kgdb and enables it* now fails to build.
-mike
