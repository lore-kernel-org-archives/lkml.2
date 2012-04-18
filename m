Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab2DRXUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:20:24 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24220 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2DRXUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:20:21 -0400
Date: Thu, 19 Apr 2012 01:20:20 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Valentin Ilie <valentin.ilie@gmail.com>
cc: geoff@infradead.org, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: ps3: ps3av.c: fixed checkpatch warnings
In-Reply-To: <1334741611-3296-1-git-send-email-valentin.ilie@gmail.com>
Message-ID: <alpine.LNX.2.00.1204190115520.14916@swampdragon.chaosbits.net>
References: <1334741611-3296-1-git-send-email-valentin.ilie@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, Valentin Ilie wrote:

> Fixed some checkpatch warnings. (review)
> Last patch didn't compile.
> 
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>

I'm wondering why you don't address the last 4 warnings and 2 errors from 
checkpatch while you are at it...

But, the changes you make here look fine to me in any case.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

