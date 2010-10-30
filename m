Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0J3QGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 12:06:16 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27384 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab0J3QGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 12:06:14 -0400
Date: Sat, 30 Oct 2010 17:55:58 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] percpu: zero memory more efficiently in
 mm/percpu.c::pcpu_mem_alloc()
In-Reply-To: <4CCC2480.70303@kernel.org>
Message-ID: <alpine.LNX.2.00.1010301754490.1572@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010292354060.24561@swampdragon.chaosbits.net> <4CCC2480.70303@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010, Tejun Heo wrote:

> Don't do vmalloc() + memset() when vzalloc() will do.
> 
> tj: dropped unnecessary temp variable ptr.
> 
I must be needing glasses, I should have seen that initially. Thanks for 
fixing that up :)

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

