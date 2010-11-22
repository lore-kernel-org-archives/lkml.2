Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0KVQzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:55:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37369 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0KVQzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:55:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=L7+28AD43z7FY+5OAsyid59/ztKXgq5sj2XR9x0Flp9iO3QeT1zJrI+tHj09Tyqpsp
         XajHl1ooYfF7nVYsQG9ucSbSd5SE1HwOyTV39+S8HrmAdnNEv3/UXtKI/FelT83yQehN
         uxvjPNiJu7Zqyg6muyOsnC+qBONHirhsLDKxg=
MIME-Version: 1.0
Date: Mon, 22 Nov 2010 09:55:14 -0700
Message-ID: <AANLkTikt2k8jC4ykYqYG_hQPAZt0-GXAvD1DPogu+AB0@mail.gmail.com>
Subject: Best place to ask this question: error with compiler.h when switching
 from 2.6.32 to 2.6.36
From: Derek Nielson <dereknielson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last week I posted on here about a problem I am having switching from
kernel 2.6.32 to 2.6.36 and compiling modules against the kernel.  I
was not able to get a response and I'm thinking it's because this is
the wrong place to post this question.  Where is the best place to ask
this kind of question?  Is there another mailing list that I should be
posting to?

Thanks

Previous Post:

I am switching from Kernel 2.6.32 to Kernel 2.6.36.  The kernel builds
fine but when I compile a module (that worked with the previously
kernel) against the new kernel I am getting an error that I don't
understand.

Here is the error:

In file included from include/linux/string.h:10,
                 from
/mnt/local/home/linux-omap-2.6/arch/arm/include/asm/uaccess.h:14,
                 from /home/my_module/my_module.c:24:
include/linux/compiler.h:62: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
‘__attribute__’ before ‘struct’
make[2]: *** [/home/my_module/my_module.o] Error 1
make[1]: *** [_module_/home/my_module] Error 2
make[1]: Leaving directory `/mnt/local/home/linux-omap-2.6'
make: *** [release] Error 2

I found this thread http://lkml.org/lkml/2007/10/17/213 and tried
following their solution but it didn't fix the problem.

Does anyone know how to fix this error?
