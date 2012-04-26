Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab2DZXZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 19:25:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab2DZXZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 19:25:48 -0400
Date: Thu, 26 Apr 2012 16:25:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next 00/12] mm: replace struct mem_cgroup_zone with
 struct lruvec
Message-Id: <20120426162546.90991b7c.akpm@linux-foundation.org>
In-Reply-To: <20120426074632.18961.17803.stgit@zurg>
References: <20120426074632.18961.17803.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012 11:53:44 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patchset depends on Johannes Weiner's patch
> "mm: memcg: count pte references from every member of the reclaimed hierarchy".
> 
> bloat-o-meter delta for patches 2..12
> 
> add/remove: 6/6 grow/shrink: 6/14 up/down: 4414/-4625 (-211)

That's the sole effect and intent of the patchset?  To save 211 bytes?

> ...
>
>  include/linux/memcontrol.h |   16 +--
>  include/linux/mmzone.h     |   14 ++
>  mm/memcontrol.c            |   33 +++--
>  mm/mmzone.c                |   14 ++
>  mm/page_alloc.c            |    8 -
>  mm/vmscan.c                |  277 ++++++++++++++++++++------------------------
>  6 files changed, 177 insertions(+), 185 deletions(-)

If so, I'm not sure that it is worth the risk and effort?
