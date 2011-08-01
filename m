Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1HAJsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:48:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46245 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1HAJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:48:01 -0400
Subject: Re: [PATCH] sched: Remove rq->avg_load_per_task
From: Peter Zijlstra <peterz@infradead.org>
To: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1312189408-17172-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1312189408-17172-1-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 11:52:05 +0200
Message-ID: <1312192325.2617.380.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 11:03 +0200, Jan H. Schönherr wrote:
> From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> 
> Since commit a2d47777 ("sched: fix stale value in average load per task")
> the variable rq->avg_load_per_task is no longer required. Remove it.

Thanks!

