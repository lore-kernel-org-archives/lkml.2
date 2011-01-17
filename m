Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1AQNPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 08:15:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:49197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1AQNPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 08:15:48 -0500
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1294890890.8089.39.camel@marge.simson.net>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <20110111171046.GL4772@in.ibm.com>
	 <1294771686.8006.15.camel@marge.simson.net>
	 <1294810842.8370.7.camel@marge.simson.net>
	 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
	 <1294890890.8089.39.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 14:16:00 +0100
Message-ID: <1295270160.30950.96.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 04:54 +0100, Mike Galbraith wrote:
> sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
> 
> If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
> not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
> tasks to the root task group, and tell __sched_setscheduler() that it's ok.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

Thanks, applied!
