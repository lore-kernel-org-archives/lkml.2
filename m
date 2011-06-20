Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab1FTOJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:09:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:56658 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1FTOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:09:39 -0400
Date: Mon, 20 Jun 2011 16:09:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Sergei Shtylyov <sshtylyov@mvista.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH][Trivial] S3C2410 bluetooth: Remove duplicate linux/leds.h
 include
In-Reply-To: <1308566964.13261.14.camel@vivanov>
Message-ID: <alpine.LNX.2.00.1106201608460.11049@pobox.suse.cz>
References: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net>  <4DFF1AA5.80508@ru.mvista.com>  <alpine.LNX.2.00.1106201232530.18991@swampdragon.chaosbits.net> <1308566964.13261.14.camel@vivanov>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Vitaliy Ivanov wrote:

> Giri,
> 
> I would still recommend to use the following patch as it corrects many 
> other places for trivial includes duplication. Also I was the first who 
> sent it:).

Unfortunately I haven't been copied on it.

> --
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> 
> Many stupid corrections of duplicated includes based on the output of scripts/checkincludes.pl.
> 
> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

I have applied it, and after performing build tests I will be pushing it 
out.

-- 
Jiri Kosina
SUSE Labs
