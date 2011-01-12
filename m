Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1ALLSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:18:15 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54310 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab1ALLSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:18:13 -0500
Subject: Re: [PATCH -tip 1/2] [PATCH -tip 1/2] sched: Reinstate group names
 in /proc/sched_debug.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110112074930.GF2723@in.ibm.com>
References: <20110111101040.GD4772@in.ibm.com>
	 <20110111101153.GE4772@in.ibm.com> <20110111124658.GA4507@zhy>
	 <20110111134244.GJ4772@in.ibm.com> <20110111140005.GA6069@zhy>
	 <20110112074930.GF2723@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 12 Jan 2011 12:18:32 +0100
Message-ID: <1294831112.19601.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 13:19 +0530, Bharata B Rao wrote:
> 
> We could, but I guess its not a recommended practice anymore to depend on
> spinlocks to protect rcu readside.

Not only is it not recommended, its a flat out bug for PREEMPT_RCU.
