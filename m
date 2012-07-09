Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2GIJTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:19:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33699 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2GIJTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <1341807891.13174.40.camel@joe2Laptop>
References: <1341802286-28281-1-git-send-email-marcos.souza.org@gmail.com>
	<1341807891.13174.40.camel@joe2Laptop>
Date: Mon, 9 Jul 2012 06:19:22 -0300
Message-ID: <CAH0vN5K0LGeKDEJJB+7R+MR5__vYVpQzMXqg1R6iBfbDHv8Qyw@mail.gmail.com>
Subject: Re: [PATCH 0/6] staging: vt6655: Cleanup in usage of macros
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
        jj@chaosbits.net, forest@alittletooquiet.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/9 Joe Perches <joe@perches.com>
>
> On Sun, 2012-07-08 at 23:51 -0300, Marcos Paulo de Souza wrote:
> > Hi kernel guys!
> >
> > This patchset aims to clean all unused and commented macros.
> >
> > For this challenge, forgotten-macros tool helped us.
>
> Perhaps there may be false positives in your code.

Not in this case. After each changes in a file, I compiled all driver again.

> Many times, macros like the below are used:

> #define SUBSYSTEM_PREFIX_FOO    1
> #define SUBSYSTEM_PREFIX_BAR    2
> #define SUBSYSTEM_PREFIX_BAZ    3
>
> #define USE_TYPE(type)  SUBSYSTEM_PREFIX_##type
>
> It doesn't seem your code knows that style.

True! The tool is under development. A more robust method will be
 implemented, but for now, the tool can find the most "easy" dead macros.

> Also, the tool might be more flexible if it was
> written using perl or python.
>
Yeah, I believe it's true!

Thanks for the comments!

But, for the changes, do I have your ack?

Thanks Joe!

--
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
