Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2BTNbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 08:31:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2BTNbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 08:31:02 -0500
Message-ID: <1329744653.2293.342.camel@twins>
Subject: Re: [PATCH] sched: Make initial SCHED_RR timeslace DEF_TIMESLICE
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 20 Feb 2012 14:30:53 +0100
In-Reply-To: <4F3C9995.3010800@ct.jp.nec.com>
References: <4F3C9995.3010800@ct.jp.nec.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 14:52 +0900, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Current the initial SCHED_RR timeslice of init_task is HZ, which means
> 1s, and is not same as the default SCHED_RR timeslice DEF_TIMESLICE.
> 
> Change that initial timeslice to the DEF_TIMESLICE.
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

No real objection, should we take the opportunity to rename to
RR_TIMESLICE or somesuch?
