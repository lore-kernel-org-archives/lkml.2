Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0CVQbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:31:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054Ab0CVQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:31:50 -0400
Date: Mon, 22 Mar 2010 09:30:41 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] mm, fs: warn on missing address space operations
Message-Id: <20100322093041.2de599f8.akpm@linux-foundation.org>
In-Reply-To: <20100322104057.GG17637@laptop>
References: <20100322053937.GA17637@laptop>
	<20100322005610.5dfa70b1.akpm@linux-foundation.org>
	<20100322104057.GG17637@laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010 21:40:57 +1100 Nick Piggin <npiggin@suse.de> wrote:

> > 
> > 	/* this fs should use block_invalidatepage() */
> > 	WARN_ON_ONCE(!invalidatepage);
> 
> Problem is that it doesn't give you the aop name (and call trace
> probably won't help).

Yes it does - you have the filename and line number.  You go there and
read "invalidatepage".  And the backtrace identifies the filesystem.



