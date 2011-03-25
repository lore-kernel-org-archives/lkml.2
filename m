Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1CYS0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:26:47 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:46036 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1CYS0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:26:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJjdjE2rRDoH/2dsb2JhbAClYXenV5xXhWkEhTqHO4NUgio
X-IronPort-AV: E=Sophos;i="4.63,244,1299456000"; 
   d="scan'208";a="282715535"
Message-ID: <4D8CDE61.6050400@cisco.com>
Date: Fri, 25 Mar 2011 12:26:41 -0600
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Emit clearer message for sys_perf_event_open
 ENOENT return
References: <1301076350-19593-1-git-send-email-daahern@cisco.com> <20110325180840.GE13180@ghostprotocols.net>
In-Reply-To: <20110325180840.GE13180@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/25/11 12:08, Arnaldo Carvalho de Melo wrote:
> Em Fri, Mar 25, 2011 at 12:05:50PM -0600, David Ahern escreveu:
>> Resend of patch sent back in January 2011 in light of recent confusion around
>> unsupported events for a given platform.
>>
>> Improve sys_perf_event_open ENOENT return handling in top and record, just
>> like 5a3446b does for stat.
>>
>> Retry of Arnaldo's patch using error instead of die which allows the fallback
>> from hardware cycles to software clock.
> 
> Please use ui__warning(""...) as it will work in the TUI too.

error() is consistent with current pattern. Is ui__warning the
preference for new messages? Is that for perf-top only?

