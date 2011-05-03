Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1ECNVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:21:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52418 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752011Ab1ECNVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:21:41 -0400
Date: Tue, 3 May 2011 14:21:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC patch 29/32] trace event asoc remove semicolons
Message-ID: <20110503132138.GL1762@opensource.wolfsonmicro.com>
References: <20110502211123.163877033@efficios.com>
 <20110502213216.050459585@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502213216.050459585@efficios.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:11:52PM -0400, Mathieu Desnoyers wrote:
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.

Can I apply this in my tree or does this depend on some earlier patch I
don't have?

> +#ifndef _TRACE_ASOC_DEF_
> +#define _TRACE_ASOC_DEF_
> +
>  struct snd_soc_jack;
>  struct snd_soc_codec;
>  struct snd_soc_card;
>  struct snd_soc_dapm_widget;
>  
> +#endif /* _TRACE_ASOC_DEF_ */

This is an unrelated change and should be split out.  Frankly I'm not
that this is an improvement anyway, the struct declarations aren't going
to do any harm...
