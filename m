Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab2IMSOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:14:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64430 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2IMSOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:14:41 -0400
Date: Thu, 13 Sep 2012 11:14:36 -0700
From: Tejun Heo <tj@kernel.org>
To: joseph.glanville@orionvm.com.au
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        NeilBrown <neilb@suse.de>, Kent Overstreet <koverstreet@google.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] block: Document lack of ordering of
 submit_bio/generic_make_request
Message-ID: <20120913181436.GF7677@google.com>
References: <1347507630-10215-1-git-send-email-joseph.glanville@orionvm.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347507630-10215-1-git-send-email-joseph.glanville@orionvm.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 01:40:30PM +1000, joseph.glanville@orionvm.com.au wrote:
> From: Joseph Glanville <joseph.glanville@orionvm.com.au>
> 
> It is worth noting here that the block layer makes no attempt
> to preserve the order of requests and that upper layers like
> journaling filesystems that require such ordering need to do so
> explicity.
> 
> Signed-off-by: Joseph Glanville <joseph.glanville@orionvm.com.au>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
