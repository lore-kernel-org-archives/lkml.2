Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2HTTxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:53:02 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:24297 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab2HTTw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:52:57 -0400
Date: Mon, 20 Aug 2012 19:52:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] mempolicy: fix a race in shared_policy_replace()
In-Reply-To: <1345480594-27032-4-git-send-email-mgorman@suse.de>
Message-ID: <00000139459858e2-456fe4a0-e238-47cc-a057-d87d6a193b6a-000000@email.amazonses.com>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de> <1345480594-27032-4-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Mel Gorman wrote:

> Kosaki's original patch for this problem was to allocate an sp node and policy
> within shared_policy_replace and initialise it when the lock is reacquired. I
> was not keen on this approach because it partially duplicates sp_alloc(). As
> the paths were sp->lock is taken are not that performance critical this
> patch converts sp->lock to sp->mutex so it can sleep when calling sp_alloc().

Reviewed-by: Christoph Lameter <cl@linux.com>
