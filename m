Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2DDMNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:13:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2DDMNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:13:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] nextfd(2)
Date: Wed, 4 Apr 2012 12:13:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20120401125741.GA7484@p183.telecom.by> <201204011921.59596.arnd@arndb.de> <4F78D141.4070609@zytor.com>
In-Reply-To: <4F78D141.4070609@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204041213.22333.arnd@arndb.de>
X-Provags-ID: V02:K0:utACgkM/lCsFFUyj7ovV0oI4FzGGuD+cmKUbnv+iuXF
 BunLBPDJbQEsjfMS0+00ve5fBOsW/WtEvrm3e3Xt1jh0Zf/p6V
 6AZPp/1/7zEHVi7MkphfSn+WY29Vk7tzfrwJxYcsYqgkOlC3Lq
 5mRYeNqWpUya1OA2UhSMmUByhocTXArkgRLRgBSj6wRIwIb4LO
 10GDHpJ6amgR0i435bwhFNESBif/r1xV5Vy1mueZ8tbMqcDm7u
 lgZKMDbXIDx0KPBf0b+445J8nQzXJPMfodoUWBDRBU/BBrn5Im
 3dhiulk66AiSXVA3UiK231SV+ofbtJ/Xvm01MJR3MIB9gk0W5o
 rvpVi+9uC4wwD4tahmC8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 April 2012, H. Peter Anvin wrote:
> On 04/01/2012 12:21 PM, Arnd Bergmann wrote:
> > On Sunday 01 April 2012, Alexey Dobriyan wrote:
> >>  arch/x86/syscalls/syscall_32.tbl |    1 +
> >>  arch/x86/syscalls/syscall_64.tbl |    1 +
> >>  fs/Makefile                      |    1 +
> >>  fs/nextfd.c                      |   27 +++++++++++++++++++++++++++
> >>  include/linux/syscalls.h         |    1 +
> >>  5 files changed, 31 insertions(+)
> > 
> > I don't have any comments on the syscall itself, but when you add one, please
> > also make the change to include/asm-generic/unistd.h so it appears in the
> > various architectures using the generic syscall table.
> 
> Arnd: do you have any interest in leveraging the syscall scripts I did
> for x86?  I have tried to make them as generic as possible, with the
> hope of getting more and more of syscall information into more easily
> processed form.

Sounds interesting, but I'm not planning to do the changes myself,
especially since I have no machine that actually uses the generic
syscall table.

Maybe I should ask the next person who submits a new architecture to
do that work, that's usually how progress in asm-generic happens
these days ;-)

	Arnd
