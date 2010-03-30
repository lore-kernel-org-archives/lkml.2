Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0C3RPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:15:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab0C3RPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:15:50 -0400
Subject: Re: [PATCH] set_cpus_allowed_ptr: don't use rq->migration_thread
 after unlock
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20100330165829.GA18284@redhat.com>
References: <20100330165829.GA18284@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 19:15:48 +0200
Message-ID: <1269969348.5258.481.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 18:58 +0200, Oleg Nesterov wrote:
> Trivial typo fix. rq->migration_thread can be NULL after task_rq_unlock(),
> this is why we have "mt" which should be used instead.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks!

