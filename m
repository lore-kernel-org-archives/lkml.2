Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab2GSUZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 16:25:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53390 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GSUZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 16:25:52 -0400
Date: Thu, 19 Jul 2012 15:25:44 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 34/34] mm/hugetlb: fix warning in
 alloc_huge_page/dequeue_huge_page_vma
Message-ID: <20120719202544.GB19392@burratino>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-35-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342708604-26540-35-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mel Gorman wrote:

> From: Konstantin Khlebnikov <khlebnikov@openvz.org>
>
> Stable note: Not tracked in Bugzilla. [get|put]_mems_allowed() is extremely
> 	expensive and severely impacted page allocator performance. This
> 	is part of a series of patches that reduce page allocator overhead.
>
> Fix a gcc warning (and bug?) introduced in cc9a6c877 ("cpuset: mm: reduce
> large amounts of memory barrier related damage v3")

I know the corresponding upstream commit was alluded to in the cover
letter, but please also mention it by name in the patch description.
Otherwise people reading the changelog will have no idea what's going
on.

Thanks and hope that helps,
Jonathan
