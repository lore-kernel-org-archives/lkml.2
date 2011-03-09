Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1CIGUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:20:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56356 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1CIGUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:20:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 5/6] proc: make check_mem_permission() return an mm_struct on success
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Roland McGrath <roland@redhat.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1299631343-4499-6-git-send-email-wilsons@start.ca>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca> <1299631343-4499-6-git-send-email-wilsons@start.ca>
Message-Id: <20110309151900.0403.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Mar 2011 15:20:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This change allows us to take advantage of access_remote_vm(), which in turn
> enables a secure mem_write() implementation.
> 
> The previous implementation of mem_write() was insecure since the target task
> could exec a setuid-root binary between the permission check and the actual
> write.  Holding a reference to the target mm_struct eliminates this
> vulnerability.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>

OK, I like this idea. So, I suppose you will resend newer version as applied Al's
comment and I'll be able to ack this.

Thanks.



