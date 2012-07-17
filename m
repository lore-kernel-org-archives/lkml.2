Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab2GQUm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:42:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54920 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab2GQUm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:42:26 -0400
Date: Tue, 17 Jul 2012 13:42:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <js1304@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: fix wrong argument of migrate_huge_pages() in
 soft_offline_huge_page()
In-Reply-To: <1342544460-20095-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1207171340420.9675@chino.kir.corp.google.com>
References: <1342544460-20095-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2012, Joonsoo Kim wrote:

> Commit a6bc32b899223a877f595ef9ddc1e89ead5072b8 ('mm: compaction: introduce
> sync-light migration for use by compaction') change declaration of
> migrate_pages() and migrate_huge_pages().
> But, it miss changing argument of migrate_huge_pages()
> in soft_offline_huge_page(). In this case, we should call with MIGRATE_SYNC.
> So change it.
> 
> Additionally, there is mismatch between type of argument and function
> declaration for migrate_pages(). So fix this simple case, too.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>

Should be cc'd to stable for 3.3+.
