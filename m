Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab2LMO1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:27:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2LMO1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:27:32 -0500
Date: Thu, 13 Dec 2012 15:27:28 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] sched: cputime: avoid multiplication overflow (in common
 cases)
Message-ID: <20121213142727.GA4609@redhat.com>
References: <20121213084430.GA2297@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213084430.GA2297@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 09:44:30AM +0100, Stanislaw Gruszka wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  kernel/sched/cputime.c |   92 +++++++++++++++++++++++++++++------------------
>  1 files changed, 57 insertions(+), 35 deletions(-)

There are recent changes in cputime.c . This patch will not apply,
please ignore it for now. I'll repost.

Stanislaw
