Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2HFTFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:05:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60262 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab2HFTFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:05:05 -0400
Message-ID: <1344279897.27828.97.camel@twins>
Subject: Re: [patch] sched,cgroup_sched: fix up task_groups list
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 06 Aug 2012 21:04:57 +0200
In-Reply-To: <1344267125.6853.33.camel@marge.simpson.net>
References: <1344267125.6853.33.camel@marge.simpson.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 17:32 +0200, Mike Galbraith wrote:
> Thinko happened during sched migration to kernel/sched, fix it up.

what's the effect.. that is what broke and why are we backporting this
to -stable?
