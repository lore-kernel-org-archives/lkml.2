Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1HIMgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:36:07 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10628 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1HIMgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:36:05 -0400
Date: Tue, 9 Aug 2011 14:36:03 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Julia Lawall <julia@diku.dk>
cc: Dave Airlie <airlied@redhat.com>, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/gpu/vga/vgaarb.c: add missing kfree
In-Reply-To: <1312892348-22615-1-git-send-email-julia@diku.dk>
Message-ID: <alpine.LNX.2.00.1108091434560.17636@swampdragon.chaosbits.net>
References: <1312892348-22615-1-git-send-email-julia@diku.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> kbuf is a buffer that is local to this function, so all of the error paths
> leaving the function should release it.
> 

I already posted a (slightly different) patch for this : 
https://lkml.org/lkml/2011/8/1/329

Nobody has picked it up yet though :-/

Well, now those responsible have two patches to chose from :-)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

