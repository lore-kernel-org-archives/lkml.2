Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938166Ab0CPRwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:52:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab0CPRwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:52:33 -0400
Date: Tue, 16 Mar 2010 18:51:23 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: cl@linux-foundation.org, lee.schermerhorn@hp.com, rientjes@google.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: fix oops in sync_mm_rss
Message-ID: <20100316175123.GD5717@random.random>
References: <20100316170808.GA29400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316170808.GA29400@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 07:08:08PM +0200, Michael S. Tsirkin wrote:
> The module in question calls use_mm and later unuse_mm from a kernel
> thread.  It is when this kernel thread is destroyed that the crash
> happens.

Looks good to me so the stats are transferred to mm before we lose
track of it.

Ack!
