Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949Ab2JLPe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:34:57 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58819 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2JLPe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:34:56 -0400
Date: Fri, 12 Oct 2012 08:34:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, dipankar@in.ibm.com
Subject: Re: [PATCH 0/5] rcu: split the rcu debugfs according to flavor
Message-ID: <20121012153415.GA2547@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1350008691-18910-1-git-send-email-wangyun@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350008691-18910-1-git-send-email-wangyun@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101215-7606-0000-0000-000004755B6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 10:24:46AM +0800, Michael Wang wrote:
> This patch set is based on:
> 	[PATCH 0/7] rcu: optimize RCU trace on the huge platform
> 
> Since folders has been created for each flavor of rcu, now we could split the
> debug objects to them.
> 
> This patch set will implement the new splitted rcu debugfs, so we could easily
> get all the info of one flavor from it's own folder.
> 
> Michael Wang (5):
> 	[PATCH 1/5] rcu: split 'rcubarrier' to each flavor
> 	[PATCH 2/5] rcu: split 'rcuboost' to each flavor
> 	[PATCH 3/5] rcu: split 'rcugp' to each flavor
> 	[PATCH 4/5] rcu: split 'rcuhier' to each flavor
> 	[PATCH 5/5] rcu: remove the old interface and stop show rsp name
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>

Queued, thank you Michael!

							Thanx, Paul

> ---
>  b/kernel/rcutree_trace.c |   27 ++++++
>  kernel/rcutree_trace.c   |  205 ++++++++++++++++++-----------------------------
>  2 files changed, 108 insertions(+), 124 deletions(-)

