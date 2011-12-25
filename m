Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1LYPzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 10:55:50 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56048 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1LYPzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 10:55:48 -0500
MIME-Version: 1.0
In-Reply-To: <1324824127-10540-1-git-send-email-geert@linux-m68k.org>
References: <1324824127-10540-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 25 Dec 2011 16:55:47 +0100
Message-ID: <CAFLxGvx7p=meL5fujby_sc+CM3UUe7jbgSzSKpqLaWwXJopo+A@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.2-rc7
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 25, 2011 at 3:42 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>  + src/arch/um/os-Linux/skas/process.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function):  => 321, 552
>  + src/arch/um/os-Linux/skas/process.c: error: (Each undeclared identifier is reported only once:  => 321
>  + src/arch/um/os-Linux/skas/process.c: error: for each function it appears in.):  => 321
>  + src/arch/um/os-Linux/start_up.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function):  => 302, 244
>  + src/arch/um/os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared (first use in this function):  => 243, 301
>  + src/arch/um/os-Linux/start_up.c: error: (Each undeclared identifier is reported only once:  => 243
>  + src/arch/um/os-Linux/start_up.c: error: for each function it appears in.):  => 243

*confused*

UML 3.2-rc7 builds fine here.
Both i386 and x86_64.

-- 
Thanks,
//richard
