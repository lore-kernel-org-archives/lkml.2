Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0EZTms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:42:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab0EZTmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:42:46 -0400
Date: Wed, 26 May 2010 15:38:19 -0400
From: Rik van Riel <riel@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH -v3 0/5] always lock the root anon_vma
Message-ID: <20100526153819.6e5cec0d@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, here are the patches to always lock the root anon_vma,
ported to the latest -mm tree.

These patches implement Linus's idea of always locking the root
anon_vma and contain all the fixes and improvements suggested 
by Andrea.

This should fix the last bits of the anon_vma locking.

v3 is identical to v2, except I gathered up the Acked-by:s that
were on list already.

Patches 4 and 5 still need some reviewing and acks...
