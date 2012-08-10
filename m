Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab2HJVQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 17:16:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58476 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010Ab2HJVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 17:16:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: xtensa port maintenance
Date: Fri, 10 Aug 2012 21:15:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-next@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@tensilica.com>,
        Kirill Krinkin <kirill.krinkin@gmail.com>
References: <50205592.1030205@gmail.com>
In-Reply-To: <50205592.1030205@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208102115.59946.arnd@arndb.de>
X-Provags-ID: V02:K0:pRMOcj5EsLyn83OkGg4Zawib/l5eUiowXBUYX7ngpX7
 RjPLw29S/HvTKHoOf7oDQF/cUU14R7rLkU7eCmYliuIUYYHq/y
 NnD0wFKyHeGp558CIpc2c24L8Sjj4AzQTw3Elsk6WNh7tkP4ut
 kWbC1xWuMeQO07LIwcM6E9oICEap/JdF/QicpOKFKO8s2yfbhT
 a4VmWLkb5OYHUQGqkcdFXjqB6XrUvhQM10+ZLBfBPaQrVbeUtr
 SAduGYxVg74A9bMgbgZt3baP2kLYMKIZvQWeNhWMjKcJg2Gz4W
 1CoGTd+rKMeriBdetj2zNWSsRsUFHyl13RgQxKXxaS8yrWwLx1
 j95RnXuOsj1/SeBOBbE8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2012, Max Filippov wrote:
> I have a couple of questions regarding the path of xtensa-specific patches
> upstream:
>     - which git tree should they be targeted for? Should I set up a tree for
>       pull requests, or will patches be picked up into some existing tree?
>       (Looks like Linus' tree is the right target. AFAIK previously xtensa
>       patches went mostly through akpm tree).

Setting up a git tree is a good first step if you want to be the official
maintainer, and if you want to get it included into linux-next.

You should also update the maintainers file to list your git tree and name,
and have Chris give you an official approval for that update. My impression
is that he is still occasionally doing work on upstream maintainance but
has moved on to other priorities now. The two of you should decide
together if you want to both be listed as maintainers or one of you
should be a primary contact and the other one doing work in the background.

>     - which mailing lists should they go to?
>       (I guess that besides linux-xtensa@linux-xtensa.org list they should go
>       to linux-kernel@vger.kernel.org for general review. Anything else?)

There is also linux-arch, which has the architecture maintainers. You can
consult that list if you have specific questions about changes that are
going on across architectures.

What kind of changes to you expect to do to the architecture port?
Are there additional platforms you want to get supported? Do you
want to stay compatible with existing user space software, or are you
thinking about moving to the new generic system call interfaces that
would require rebuilding all user land binaries?

	Arnd
