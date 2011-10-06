Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab1JFVyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 17:54:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37297 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759294Ab1JFVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 17:54:48 -0400
Date: Thu, 6 Oct 2011 14:54:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/3] Fix compaction about mlocked pages
Message-Id: <20111006145445.ed8d6dbb.akpm@linux-foundation.org>
In-Reply-To: <cover.1321112552.git.minchan.kim@gmail.com>
References: <cover.1321112552.git.minchan.kim@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Nov 2011 01:37:40 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> This patch's goal is to enable mlocked page migration.
> The compaction can migrate mlocked page to get a contiguous memory unlike lumpy.
> 

This patch series appears to be a resend of stuff I already have.

Given the various concerns which were voiced during review of
mm-compaction-compact-unevictable-pages.patch and the uncertainty of
the overall usefulness of the feature, I'm inclined to drop

mm-compaction-compact-unevictable-pages.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-compaction-accounting-fix.patch

for now, OK?
