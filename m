Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0KVRgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:36:12 -0500
Received: from legolas.restena.lu ([158.64.1.34]:54722 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0KVRgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:36:10 -0500
Date: Mon, 22 Nov 2010 18:35:54 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Derek Nielson <dereknielson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Best place to ask this question: error with compiler.h when
 switching from 2.6.32 to 2.6.36
Message-ID: <20101122183554.764aa480@neptune.home>
In-Reply-To: <AANLkTikt2k8jC4ykYqYG_hQPAZt0-GXAvD1DPogu+AB0@mail.gmail.com>
References: <AANLkTikt2k8jC4ykYqYG_hQPAZt0-GXAvD1DPogu+AB0@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You should post the corresponding code in my_module.c around line 24
(preferably a link to the whole code of your external module).

The error alone won't help too much as probably it's happening more or
less deep inside macros, thus the whole parameters to the macro are
required to understand.

Bruno


On Mon, 22 November 2010 Derek Nielson <dereknielson@gmail.com> wrote:
> Last week I posted on here about a problem I am having switching from
> kernel 2.6.32 to 2.6.36 and compiling modules against the kernel.  I
> was not able to get a response and I'm thinking it's because this is
> the wrong place to post this question.  Where is the best place to ask
> this kind of question?  Is there another mailing list that I should be
> posting to?
> 
> Thanks
> 
> Previous Post:
> 
> I am switching from Kernel 2.6.32 to Kernel 2.6.36.  The kernel builds
> fine but when I compile a module (that worked with the previously
> kernel) against the new kernel I am getting an error that I don't
> understand.
> 
> Here is the error:
> 
> In file included from include/linux/string.h:10,
>                  from
> /mnt/local/home/linux-omap-2.6/arch/arm/include/asm/uaccess.h:14,
>                  from /home/my_module/my_module.c:24:
> include/linux/compiler.h:62: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
> ‘__attribute__’ before ‘struct’
> make[2]: *** [/home/my_module/my_module.o] Error 1
> make[1]: *** [_module_/home/my_module] Error 2
> make[1]: Leaving directory `/mnt/local/home/linux-omap-2.6'
> make: *** [release] Error 2
> 
> I found this thread http://lkml.org/lkml/2007/10/17/213 and tried
> following their solution but it didn't fix the problem.
> 
> Does anyone know how to fix this error?
