Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1KWMoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:44:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42012 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1KWMoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:44:19 -0500
Message-ID: <1322052249.14799.59.camel@twins>
Subject: Re: [PATCH 0/5] dirty throttling bits for 3.3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 13:44:09 +0100
In-Reply-To: <20111121130342.211953629@intel.com>
References: <20111121130342.211953629@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 21:03 +0800, Wu Fengguang wrote:
> Hi,
> 
> I'd like to push these 5 dirty throttling improvements to linux-next,
> targeting for inclusion in Linux 3.3.
> 
> It's a comfortably small series for review ;) And there are no changes since
> the last v12 post. (I went through them once again but find nothing to change.)
> 
>  [PATCH 1/5] writeback: balanced_rate cannot exceed write bandwidth
>  [PATCH 2/5] writeback: charge leaked page dirties to active tasks
>  [PATCH 3/5] writeback: fix dirtied pages accounting on sub-page writes
>  [PATCH 4/5] writeback: fix dirtied pages accounting on redirty
>  [PATCH 5/5] writeback: dirty ratelimit - think time compensation

Given the updates I'm ok with this series,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks!
