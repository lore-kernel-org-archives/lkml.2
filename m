Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945960Ab2KNXKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:10:22 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36474 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945923Ab2KNXKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:10:21 -0500
Date: Wed, 14 Nov 2012 18:10:19 -0500 (EST)
Message-Id: <20121114.181019.152264317780389205.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, walken@google.com, riel@redhat.com
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121114150919.19c1633a.akpm@linux-foundation.org>
References: <20121114141847.fab752c2.akpm@linux-foundation.org>
	<20121114.173059.2152995770988231211.davem@davemloft.net>
	<20121114150919.19c1633a.akpm@linux-foundation.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 14 Nov 2012 15:09:19 -0800

> I suspect that most people expect "color".  And given that this
> patchset removes COLOUR_ALIGN_DOWN (and should have removed
> arch/sparc/kernel/sys_sparc_32.c:COLOR_ALIGN), we end up with

That's fine.
