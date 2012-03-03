Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2CCIso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 03:48:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50033 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2CCIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 03:48:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of maciej.rutecki@gmail.com designates 10.213.33.13 as permitted sender) smtp.mail=maciej.rutecki@gmail.com; dkim=pass header.i=maciej.rutecki@gmail.com
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
Subject: Re: Error compiling autofs4 with 3.3-rc4
Date: Sat, 3 Mar 2012 09:48:37 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1330216608.19195.3.camel@firefly>
In-Reply-To: <1330216608.19195.3.camel@firefly>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203030948.37833.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 26 lutego 2012 o 01:36:48 Nathan A. Mourey II wrote:
> I got this error while compiling the 3.3-rc5 kernel:
> 
> peach linux-3.3-rc5 # make bzImage
> 
> make[1]: Nothing to be done for `all'.
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC      fs/autofs4/inode.o
> fs/autofs4/inode.c: In function 'autofs4_fill_super':
> fs/autofs4/inode.c:228:2: error: implicit declaration of function
> 'is_compat_task'
> make[2]: *** [fs/autofs4/inode.o] Error 1
> make[1]: *** [fs/autofs4] Error 2
> make: *** [fs] Error 2
> 
[...]

Please add your email to:
https://bugzilla.kernel.org/show_bug.cgi?id=42851

for regression tracking.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
