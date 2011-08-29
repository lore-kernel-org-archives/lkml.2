Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1H2MxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:53:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50419 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab1H2MxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:53:11 -0400
Subject: Re: [PATCH] perf_event: fix broken calc_timer_values()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, emunson@mgebm.net,
        vweaver1@eecs.utk.edu
Date: Mon, 29 Aug 2011 14:53:01 +0200
In-Reply-To: <20110829124112.GA4828@quad>
References: <20110829124112.GA4828@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314622381.2816.17.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 14:41 +0200, Stephane Eranian wrote:

> @@ -3354,8 +3354,8 @@ static int perf_event_index(struct perf_event *event)
>  }
>  
>  static void calc_timer_values(struct perf_event *event,
> -				u64 *running,
> -				u64 *enabled)
> +				u64 *enabled,
> +				u64 *running)
>  {
>  	u64 now, ctx_time;
>  

Urgh, nice catch.. I'll queue it for perf/urgent and Cc stable for 3.0.x
