Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2JAEpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 00:45:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33521 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2JAEpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 00:45:50 -0400
Date: Mon, 01 Oct 2012 00:45:47 -0400 (EDT)
Message-Id: <20121001.004547.291872991703576360.davem@davemloft.net>
To: jgunthorpe@obsidianresearch.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix userspace compilation of ip_tables.h/ip6_tables.h
 in C++ mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120930231737.GA30637@obsidianresearch.com>
References: <20120930231737.GA30637@obsidianresearch.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Sun, 30 Sep 2012 17:17:37 -0600

> The implicit cast from void * is not allowed for C++ compilers, and the
> arithmetic on void * generates warnings in C++ mode.
> 
> $ g++ -c t.cc
> ip_tables.h:221:24: warning: pointer of type 'void *' used in arithmetic
> ip_tables.h:221:24: error: invalid conversion from 'void*' to 'xt_entry_target*'
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Please post netfilter patches to netfilter-devel@vger.kernel.org

Thank you.
