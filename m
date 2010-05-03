Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab0ECOh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 10:37:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932462Ab0ECOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 10:37:57 -0400
Date: Mon, 3 May 2010 07:36:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nilfs <linux-nilfs@vger.kernel.org>
Subject: Re: [PATCH] nilfs2: fix sync silent failure
In-Reply-To: <20100503125313.GC27497@kernel.dk>
Message-ID: <alpine.LFD.2.00.1005030736030.5478@i5.linux-foundation.org>
References: <20100503.210048.267730124.ryusuke@osrg.net> <20100503125313.GC27497@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 May 2010, Jens Axboe wrote:
> 
> Linus, will you pick this one up, or do you want me to merge it and send
> it your way?

I took it. Thanks guys,

		Linus
