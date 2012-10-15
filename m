Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2JOXik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:38:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37099 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab2JOXij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:38:39 -0400
Date: Mon, 15 Oct 2012 16:38:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] srcu: Add DEFINE_SRCU()
Message-ID: <20121015233831.GA11650@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101523-5806-0000-0000-00001AABF2B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 01:14:13AM +0800, Lai Jiangshan wrote:
> These patches add a simple DEFINE_SRCU() which define and init
> the srcu struct in build time, and allow us use srcu in very early
> boot time.

So queue for 3.8, thank you!

						Thanx, Paul

> Lai Jiangshan (4):
>   srcu: add my name
>   srcu: export process_srcu()
>   srcu: add DEFINE_SRCU
>   rcutorture: use DEFINE_STATIC_SRCU()
> 
>  include/linux/srcu.h |   34 ++++++++++++++++++++++++++++++++++
>  kernel/rcutorture.c  |   41 ++++++-----------------------------------
>  kernel/srcu.c        |    8 ++++----
>  3 files changed, 44 insertions(+), 39 deletions(-)
> 
> -- 
> 1.7.7.6
> 

