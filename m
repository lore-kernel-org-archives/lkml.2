Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2FYLsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:48:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab2FYLsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:48:17 -0400
Date: Mon, 25 Jun 2012 19:48:07 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] memcg: cleanup memory cgroup
Message-ID: <20120625114807.GD12148@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1340616793-10142-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340616793-10142-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, just ignore!

On Mon, Jun 25, 2012 at 05:33:13PM +0800, Wanpeng Li wrote:
>From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
>Changelog:
>
>* drop memcg: move recent_rotated and recent_scanned informations patch
>* drop memcg: replace unsigned long by u64 to avoid overflow
>* drop memcg: optimize memcg_get_hierarchical_limit
>
>Wanpeng Li (3):
>
>memcg: cleanup useless LRU_ALL_EVICTABLE
>memcg: change mem_control_xxx to mem_cgroup_xxx
>memcg: cleanup all typo in memory cgroup
>
>Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>---
> include/linux/mmzone.h |    2 +-
> include/linux/vmstat.h |    2 +-
> mm/memcontrol.c        |   40 +++++++++++++++++++---------------------
> 3 files changed, 21 insertions(+), 23 deletions(-)
