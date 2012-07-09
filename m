Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2GIWgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:36:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54089 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2GIWgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:36:06 -0400
Date: Mon, 9 Jul 2012 15:35:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] shmem/tmpfs: three late patches
Message-ID: <alpine.LSU.2.00.1207091533001.2051@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's three little shmem/tmpfs patches against v3.5-rc6.
Either the first should go in before v3.5 final, or it should not go
in at all.  The second and third are independent of it: I'd like them
in v3.5, but don't have a clinching argument: see what you think.

[PATCH 1/3] tmpfs: revert SEEK_DATA and SEEK_HOLE
[PATCH 2/3] shmem: fix negative rss in memcg memory.stat
[PATCH 3/3] shmem: cleanup shmem_add_to_page_cache

 mm/shmem.c |  193 +++++++++++++++------------------------------------
 1 file changed, 58 insertions(+), 135 deletions(-)

Thanks,
Hugh
