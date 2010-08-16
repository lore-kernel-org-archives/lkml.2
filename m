Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0HPLPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:15:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:47588 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab0HPLPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:15:47 -0400
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Peter Zijlstra <peterz@infradead.org>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Renninger <trenn@suse.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Len Brown <len.brown@intel.com>,
        Arjan Van De Ven <arjan@linux.intel.com>
In-Reply-To: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 13:15:36 +0200
Message-ID: <1281957336.1926.1230.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 13:09 +0200, Jean Pihet wrote:
> This patch adds new generic events for dynamic power management
> tracing:
> - clock events class: used for clock enable/disable and for
>    clock rate change,
> - power_domain events class: used for power domains transitions.
> 
> The OMAP architecture is using the new events for PM debugging, however
> the new events are made generic enough to be used by all platforms.

Even though I'm blissfully ignorant on power stuffs, the proposed set of
trace thingies doesn't appear to even start covering x86..

CC'ed people who know more on the subject.
