Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030765Ab2CTQbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab2CTQbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:31:46 -0400
Date: Tue, 20 Mar 2012 12:31:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [patch]blk: use correct sectors limitation for discard request
Message-ID: <20120320163142.GF17071@redhat.com>
References: <4F62EE56.6000702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F62EE56.6000702@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 03:40:06PM +0800, Shaohua Li wrote:
> 
> Subject: blk: use correct sectors limitation for discard request
> 
> max_discard_sectors doesn't equal to max_sectors/max_hw_sectors.
> Without this,
> discard request merge might be ignored.

In other patch you are making discard request non-mergeable. So what's
the purpose of this patch.

Thanks
Vivek
