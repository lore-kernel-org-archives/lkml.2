Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1GQQK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 12:10:59 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18673 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1GQQK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 12:10:58 -0400
Date: Sun, 17 Jul 2011 18:10:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Should SUBLEVEL be removed for 3.x ?
In-Reply-To: <CA+55aFycfQ7W8gST=toEySX=2-Baoo94QLS+YWFg8HVz0c7F3Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1107171808440.32359@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107110000280.2818@swampdragon.chaosbits.net> <alpine.LNX.2.00.1107132351390.22281@swampdragon.chaosbits.net> <CA+55aFycfQ7W8gST=toEySX=2-Baoo94QLS+YWFg8HVz0c7F3Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011, Linus Torvalds wrote:

> On Wed, Jul 13, 2011 at 2:53 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> >
> > Would be nice to get this clarified before 3.0 happens :-)
> 
> I don't think I can realistically make it call itself 3.0, even though
> the *tag* will certainly be just 3.0.
> 
> I considered making it a config option (so that people with fixed
> tools could do it), but ..
> 
Ok, so SUBLEVEL will stay. I guess that the stable kernels will then just 
use that and EXTRAVERSION will go away - right?


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

