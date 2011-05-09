Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1EIHqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:46:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43736 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1EIHql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:46:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 5/8] mm: remove check_huge_range()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303947349-3620-6-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca> <1303947349-3620-6-git-send-email-wilsons@start.ca>
Message-Id: <20110509164822.165F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 16:46:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This function has been superseded by gather_hugetbl_stats() and is no
> longer needed.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>
> ---
>  mm/mempolicy.c |   35 -----------------------------------
>  1 files changed, 0 insertions(+), 35 deletions(-)

Looks good.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




