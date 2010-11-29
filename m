Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0K2P1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:27:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0K2P1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:27:04 -0500
Date: Mon, 29 Nov 2010 10:26:36 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
 threshold when memory is low
Message-ID: <20101129152636.GI15818@bombadil.infradead.org>
References: <1288169256-7174-1-git-send-email-mel@csn.ul.ie>
 <1288169256-7174-2-git-send-email-mel@csn.ul.ie>
 <20101126160619.GP22651@bombadil.infradead.org>
 <20101129095618.GB13268@csn.ul.ie>
 <20101129131626.GF15818@bombadil.infradead.org>
 <20101129150824.GF13268@csn.ul.ie>
 <20101129152230.GH15818@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129152230.GH15818@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 10:22:30AM -0500, Kyle McMartin wrote:
> Hrm, I don't think it is, I think the ones with '?' are just artifacts
> because we don't have a proper unwinder. Oh! Thanks! I just found a bug
> in our configs... We don't have CONFIG_FRAME_POINTER set because
> CONFIG_DEBUG_KERNEL got unset in the 'production' configs... I'll fix
> that up.
> 

Oops, no, misdiagnosed that by accidentally grepping for FRAME_POINTERS
instead of FRAME_POINTER... it's set in our configs.
