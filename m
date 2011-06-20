Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1FTK7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:59:02 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13103 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1FTK7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:59:00 -0400
Date: Mon, 20 Jun 2011 12:50:14 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH][Trivial] S3C2410 bluetooth: Remove duplicate linux/leds.h
 include
In-Reply-To: <BANLkTimjoiDxDX-_Qg4U6TSW6jjEa5xSsw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1106201249290.18991@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net> <BANLkTimjoiDxDX-_Qg4U6TSW6jjEa5xSsw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Vitaliy Ivanov wrote:

[...]
> Some time ago I already sent a patch to handle all the headers
> duplication corrections. Please check this:
> 
> https://lkml.org/lkml/2011/6/16/301
> 
> It should handle all the cases you described at:
> 
> https://lkml.org/lkml/2011/6/20/72
> https://lkml.org/lkml/2011/6/20/78
> https://lkml.org/lkml/2011/6/20/75
> 
> I didn't receive any comments and still can see that it's not in
> mainline Linus' tree.
> 

Ok, I was not aware of that patch. I'll take a look at it later when I 
have some more time.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

