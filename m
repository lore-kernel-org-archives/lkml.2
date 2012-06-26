Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab2FZQye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:54:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39251 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab2FZQyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:54:33 -0400
Date: Tue, 26 Jun 2012 18:54:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Rafael Aquini <aquini@redhat.com>,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/4] mm: introduce compaction and migration for virtio ballooned pages
Message-ID: <20120626165432.GZ11413@one.firstfloor.org>
References: <cover.1340665087.git.aquini@redhat.com> <7f83427b3894af7969c67acc0f27ab5aa68b4279.1340665087.git.aquini@redhat.com> <20120626101729.GF8103@csn.ul.ie> <20120626165258.GY11413@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626165258.GY11413@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not fully sure what putback_balloon_page does, but if it just tests
> a bit (without non variable test_bit) it should be ok.
         ^^^^^^^^^^^^^

should be "without variable ..."

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
