Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab0DVOfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:35:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755293Ab0DVOfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:35:08 -0400
Date: Thu, 22 Apr 2010 07:33:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
In-Reply-To: <alpine.LFD.2.00.1004220724170.9086@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004220730280.9086@i5.linux-foundation.org>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org> <20100422062631.GC27309@logfs.org>
 <alpine.LFD.2.00.1004220724170.9086@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Apr 2010, Linus Torvalds wrote:
>
> Umm. Why not just remove the two-liner? It was incorrect. The comment says 
> "this should be safe", and if it wasn't, then the commit that caused this 
> all was total crap to begin with.

Grr. Ok, so we do need it. Because Jens made it not work without it, and 
didn't fix up the filesystems, just added a random comment saying "we 
shouldn't need to".

Double-grr. I hate misleading comments. It makes the patch and the code 
look like people knew what they were doing.

Jens - please help fix this up.

		Linus
