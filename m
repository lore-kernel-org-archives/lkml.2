Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1FTKnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:43:24 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12992 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1FTKnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:43:22 -0400
Date: Mon, 20 Jun 2011 12:34:37 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Sergei Shtylyov <sshtylyov@mvista.com>
cc: linux-arm-kernel@lists.infradead.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH][Trivial] S3C2410 bluetooth: Remove duplicate linux/leds.h
 include
In-Reply-To: <4DFF1AA5.80508@ru.mvista.com>
Message-ID: <alpine.LNX.2.00.1106201232530.18991@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net> <4DFF1AA5.80508@ru.mvista.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Sergei Shtylyov wrote:

> Hello.
> 
> On 20-06-2011 12:40, Jesper Juhl wrote:
> 
> > Remove the duplicate inclusion of linux/leds.h from
> > arch/arm/mach-s3c2410/h1940-bluetooth.c that was added by commit 50e2d10d.
> 
>    Pelase also specify that commit's summary in parens.
> 

Anyone can just do a "git show 50e2d10d" to read it. But sure, here's a 
new patch description:

Remove the duplicate inclusion of linux/leds.h from 
arch/arm/mach-s3c2410/h1940-bluetooth.c that was added by commit 50e2d10d 
(ARM: S3C2410: H1940: Use leds-gpio driver for LEDs managing).


> > Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> 
> WBR, Sergei
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

