Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2BBUiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:38:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41524 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab2BBUio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:38:44 -0500
Date: Thu, 2 Feb 2012 12:38:40 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] block: relocate elevator initialized test from
 blk_cleanup_queue() to blk_drain_queue()
Message-ID: <20120202203840.GJ19837@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-3-git-send-email-tj@kernel.org>
 <20120202202042.GC1723@redhat.com>
 <20120202203513.GH19837@google.com>
 <20120202203708.GA30258@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202203708.GA30258@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:37:08PM -0500, Vivek Goyal wrote:
> > Hmmm... probably, but doesn't that mean the code is already broken for
> > bio based drivers using throtl?
> 
> Yes looks like it is already broken for bio based drivers. So it is a fix
> independent of this patch/patch series.

Yeah, I'll write up a separate fix patch for mainline.

Thanks.

-- 
tejun
