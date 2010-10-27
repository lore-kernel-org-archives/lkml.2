Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920Ab0J0LPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:15:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:10998 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732Ab0J0LPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:15:50 -0400
Message-Id: <b9dded$gtgeib@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,246,1286175600"; 
   d="scan'208";a="567818827"
Date: Wed, 27 Oct 2010 12:15:45 +0100
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] mm,x86: fix kmap_atomic_push vs ioremap_32.c
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
References: <20100918155326.478277313@chello.nl> <849307$a582r7@azsmga001.ch.intel.com> <1288175638.15336.1538.camel@twins>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1288175638.15336.1538.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 12:33:58 +0200, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Christoph just complained about the same on IRC, the below seems to cure
> things for i386-defconfig with CONFIG_HIGHMEM=n

Compiles and boots on the misbehaving box.
Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
