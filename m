Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0EGOyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:54:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505Ab0EGOyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:54:02 -0400
Date: Fri, 7 May 2010 07:51:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data from compressed memory
 (v2)
In-Reply-To: <4BE3C4CC.8050307@cs.helsinki.fi>
Message-ID: <alpine.LFD.2.00.1005070750510.901@i5.linux-foundation.org>
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org> <4BE3C4CC.8050307@cs.helsinki.fi>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 May 2010, Pekka Enberg wrote:
> 
> The series looks good to me:
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Yeah, I think I'm finally ok with it too.

	Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

Thanks,

		Linus
