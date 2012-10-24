Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab2JXKck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:32:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59006 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2JXKcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:32:39 -0400
Date: Wed, 24 Oct 2012 12:32:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@redhat.com,
        acme@ghostprotocols.net, walken@google.com, akpm@linux-foundation.org
Subject: Re: make DESTDIR=something -C linux/tools O=<somewhere>/tools
 perf_install fails during compile - ../../lib/rbtree.c:24:36: error:
 linux/rbtree_augmented.h ?
Message-ID: <20121024103234.GA10691@gmail.com>
References: <20121012133719.GA7169@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012133719.GA7169@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> Hey Ingo, Andrew, Michel, etc.
> 
> Was wondering if you had seen similar errors? I am building perf out-of-tree
> (so using the O= and -C combination). This did used to work in v3.6.
> 
> It looks like the libtree_augmented.h is missing somehow?

It's working for me now - can you confirm that it's all fixed in 
Linus's latest tree?

Thanks,

	Ingo
