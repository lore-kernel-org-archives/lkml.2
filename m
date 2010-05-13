Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0EMGP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:15:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60411 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab0EMGPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:15:22 -0400
Date: Thu, 13 May 2010 08:15:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Carsten Emde <C.Emde@osadl.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/4] tracing/sched: Fix task states in sched switch event
Message-ID: <20100513061511.GE697@elte.hu>
References: <20100513012110.558313399@goodmis.org>
 <20100513012301.719314329@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513012301.719314329@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> +#define TASK_STATE_X(num) TASK_STATE_##num " (" DESCR_TASK_STATE_##num ")"
>  static const char *task_state_array[] = {
> -	"R (running)",		/*   0 */
> -	"S (sleeping)",		/*   1 */
> -	"D (disk sleep)",	/*   2 */
> -	"T (stopped)",		/*   4 */
> -	"t (tracing stop)",	/*   8 */
> -	"Z (zombie)",		/*  16 */
> -	"X (dead)",		/*  32 */
> -	"x (dead)",		/*  64 */
> -	"K (wakekill)",		/* 128 */
> -	"W (waking)",		/* 256 */
> +	TASK_STATE_X(0),
> +	TASK_STATE_X(1),
> +	TASK_STATE_X(2),
> +	TASK_STATE_X(4),
> +	TASK_STATE_X(8),
> +	TASK_STATE_X(16),
> +	TASK_STATE_X(32),
> +	TASK_STATE_X(64),
> +	TASK_STATE_X(128),
> +	TASK_STATE_X(256)

Hm, this is totally unreadable. What does 'TASK_STATE_X' mean??

	Ingo
