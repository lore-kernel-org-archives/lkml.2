Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2JPTMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:12:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49706 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2JPTMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:12:03 -0400
Date: Tue, 16 Oct 2012 12:11:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Joseph Glanville <joseph.glanville@orionvm.com.au>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups <cgroups@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: lift the initial queue bypass mode on
 blk_register_queue() instead of blk_init_allocated_queue()
Message-ID: <20121016191158.GC16166@google.com>
References: <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
 <20120920191716.GI4681@redhat.com>
 <20120920192038.GJ28934@google.com>
 <20120920195759.GK4681@redhat.com>
 <20120920201815.GB7264@google.com>
 <20120920210852.GC7264@google.com>
 <505C6AD4.6030206@kernel.dk>
 <CAOzFzEiCWazLEfjo=w8c+7qCce98Q6faW1uwGm-tRmCNPJUztw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzFzEiCWazLEfjo=w8c+7qCce98Q6faW1uwGm-tRmCNPJUztw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 09:00:30PM +1100, Joseph Glanville wrote:
> Has this patch been marked for stable?

Yes, both have been marked.

Thanks.

-- 
tejun
