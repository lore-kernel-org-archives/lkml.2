Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1CPC5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:57:23 -0400
Received: from waste.org ([173.11.57.241]:33055 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab1CPC5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:57:22 -0400
Subject: Re: [PATCH 0/8] mm/slub: Add SLUB_RANDOMIZE support
From: Matt Mackall <mpm@selenic.com>
To: George Spelvin <linux@horizon.com>
Cc: penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110316022804.27676.qmail@science.horizon.com>
References: <20110316022804.27676.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 21:57:18 -0500
Message-ID: <1300244238.3128.420.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-13 at 20:20 -0400, George Spelvin wrote:
> As a followup to the "[PATCH] Make /proc/slabinfo 0400" thread, this
> is a patch series to randomize the order of object allocations within
> a page.  It can be extended to SLAB and SLOB if desired.  Mostly it's
> for benchmarking and discussion.

I've spent a while thinking about this over the past few weeks, and I
really don't think it's productive to try to randomize the allocators.
It provides negligible defense and just makes life harder for kernel
hackers.

(And you definitely can't randomize SLOB like this.)

> Patches 1-4 and 8 touch drivers/char/random.c, to add support for
> efficiently generating a series of uniform random integers in small
> ranges.  Is this okay with Herbert & Matt?

But I will look at these.

-- 
Mathematics is the supreme nostalgia of our time.


