Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2JMJJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:09:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2JMJJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:09:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/25] asm-generic: Convert all to use Kbuild file
Date: Sat, 13 Oct 2012 09:09:52 +0000
Message-ID: <1762180.8nMW7nCt7B@wuerfel>
User-Agent: KMail/4.9 beta2 (Linux/3.5.0-7-generic; KDE/4.8.90; x86_64; ; )
In-Reply-To: <20121013022632.024527228@goodmis.org>
References: <20121013022632.024527228@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:K5/uTDikTzwe0IO/0EXSOOJMLT2qIwBI7l7FKVYfdWQ
 j6vNsrP1qqzdZs+ukQFVyvv+ACeLIq75tGOxpCMLTtMBvU788w
 pPuiFS8E2dAWI6NiApH848YunxMYqPj7W6YheKmotVNVSNQ1Uh
 EqqTt+EnUj6s9nR2lUZB3wQFGk0EZRkFSg1n21uaIc/lVpcL3h
 GSCGBBGTTcBnuwAgRc7n6zo4JxI0+2Qwgd8MgYztWYVw2zY1g6
 M90NCMm3YBYp4awVkdewuq34DEFaWfnTvfHNcf+VoZtm5PW4OJ
 mzCI51/PfCRu8IDnPlGYzmWll2DmXbW5dd3MDCo2BSDt7zKmUd
 9fCy9yS2MseEXwE4hoqs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2012 22:26:32 Steven Rostedt wrote:
> 
> Please feel free to pluck these patches into your architecture and
> run them to make sure that they boot as well (I only had the compiler
> and not the box... Also I only tested with defconfig, I may have
> broken other configs).
> 
> One note, the best thing about these changes is:
> 
>  390 files changed, 369 insertions(+), 1378 deletions(-)

Thanks a lot for doing this! I had initially converted a bunch of
architectures to use the asm-generic files this way, but gave up
after some of them turned out to be too much work to get in.

Note that while you are addressing all the obvious candidates that
have only a single #include statement in them, there is room to take
this further because a lot of the other header files in architectures
are still identical to their asm-generic counterparts (aside from
whitespace and comments). I would recommend to arch maintainers that
have not already done so to go through all the headers and replace
the identical ones with generated headers that include the asm-generic
version.

	Arnd
