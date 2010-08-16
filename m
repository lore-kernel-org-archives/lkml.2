Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0HPLZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:25:46 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33390 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab0HPLZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:25:44 -0400
MIME-Version: 1.0
X-Originating-IP: [81.240.54.178]
In-Reply-To: <1281957336.1926.1230.camel@laptop>
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
	<1281957336.1926.1230.camel@laptop>
Date: Mon, 16 Aug 2010 13:25:43 +0200
Message-ID: <AANLkTimcXHBw+cbPWATXv=VGFwCHvf8Has4H6bLXPFd=@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Renninger <trenn@suse.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Len Brown <len.brown@intel.com>,
        Arjan Van De Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 1:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-08-16 at 13:09 +0200, Jean Pihet wrote:
>> This patch adds new generic events for dynamic power management
>> tracing:
>> - clock events class: used for clock enable/disable and for
>>    clock rate change,
>> - power_domain events class: used for power domains transitions.
>>
>> The OMAP architecture is using the new events for PM debugging, however
>> the new events are made generic enough to be used by all platforms.
>
> Even though I'm blissfully ignorant on power stuffs, the proposed set of
> trace thingies doesn't appear to even start covering x86..
Ok, let's discuss it! The intention is to provide new generic events.

>
> CC'ed people who know more on the subject.
>
Thanks!
