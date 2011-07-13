Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab1GMUoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:44:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:40019 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1GMUoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:44:38 -0400
Subject: Re: [PATCH 5/6] sched: Use leaf_cfs_rqs in load_balance_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1310580816-10861-6-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310580816-10861-6-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 22:44:26 +0200
Message-ID: <1310589866.2586.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 20:13 +0200, Jan H. Schönherr wrote:
> Since commit 3d4b47b4 ("sched: Implement on-demand (active) cfs_rq list")
> the leaf_cfs_rqs provide an advantage over the task_group list.
> 
> Make use of it in load_balance_fair(), so that we do not unnecessarily
> iterate over empty cfs_rqs where we cannot pull anything from.

I just send a similar patch today:

https://lkml.org/lkml/2011/7/13/94

