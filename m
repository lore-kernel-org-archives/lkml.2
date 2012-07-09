Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2GIKnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:43:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58101 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab2GIKnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:43:51 -0400
Date: Mon, 9 Jul 2012 03:43:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wanpeng Li <liwp.linux@gmail.com>
cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: split out
 is_hugetlb_entry_migration_or_hwpoison
In-Reply-To: <1341828761-11195-1-git-send-email-liwp.linux@gmail.com>
Message-ID: <alpine.DEB.2.00.1207090343110.8224@chino.kir.corp.google.com>
References: <1341828761-11195-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Wanpeng Li wrote:

> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Code was duplicated in two functions, clean it up.
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> ---
>  mm/hugetlb.c |   20 +++++++++-----------
>  1 files changed, 9 insertions(+), 11 deletions(-)

Nack, this makes the code more convoluted then the hugetlb code already is 
and savings two lines of code isn't worth it.
