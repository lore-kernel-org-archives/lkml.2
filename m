Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1BVXVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:21:51 -0500
Received: from tex.lwn.net ([70.33.254.29]:35813 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab1BVXVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:21:50 -0500
Date: Tue, 22 Feb 2011 16:21:47 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] page_cgroup: make page tracking available for blkio
Message-ID: <20110222162147.02e772b3@bike.lwn.net>
In-Reply-To: <20110222230630.GL28269@redhat.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
	<1298394776-9957-4-git-send-email-arighi@develer.com>
	<20110222130145.37cb151e@bike.lwn.net>
	<20110222230146.GB23723@linux.develer.com>
	<20110222230630.GL28269@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 18:06:30 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> I think John suggested replacing mem_cgroup pointer with css_set so that
> size of the strcuture does not increase but it leads extra level of 
> indirection.

That is what I was thinking.  But I did also say it's probably premature
generalization at this point, especially given that there'd be a runtime
cost.

jon
