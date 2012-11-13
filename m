Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2KMAtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:49:55 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34123 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab2KMAty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:49:54 -0500
Date: Mon, 12 Nov 2012 19:49:47 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/4] bootmem: remove not implemented function call,
 bootmem_arch_preferred_node()
Message-ID: <20121113004947.GA10092@cmpxchg.org>
References: <1352737915-30906-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352737915-30906-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 01:31:52AM +0900, Joonsoo Kim wrote:
> There is no implementation of bootmeme_arch_preferred_node() and
> call for this function will makes compile-error.
> So, remove it.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
