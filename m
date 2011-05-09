Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1EIHvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:51:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41624 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1EIHvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:51:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 7/8] proc: make struct proc_maps_private truly private
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303947349-3620-8-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca> <1303947349-3620-8-git-send-email-wilsons@start.ca>
Message-Id: <20110509165255.1667.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 16:51:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now that mm/mempolicy.c is no longer implementing /proc/pid/numa_maps
> there is no need to export struct proc_maps_private to the world.  Move
> it to fs/proc/internal.h instead.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>
> ---
>  fs/proc/internal.h      |    8 ++++++++
>  include/linux/proc_fs.h |    8 --------
>  2 files changed, 8 insertions(+), 8 deletions(-)

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



