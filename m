Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1E3IYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:24:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57076 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab1E3IYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:24:41 -0400
Date: Mon, 30 May 2011 10:24:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH v2] perf stat: clarify unsupported events from uncounted
 events
Message-ID: <20110530082434.GB30513@elte.hu>
References: <1306519614-19463-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306519614-19463-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> +++ b/tools/perf/util/evsel.h
> @@ -61,6 +61,7 @@ struct perf_evsel {
>  		off_t		id_offset;
>  	};
>  	struct cgroup_sel	*cgrp;
> +	bool supported;

Nit: when adding new fields to structures please try to keep the 
vertical alignment of existing fields.

Thanks,

	Ingo
