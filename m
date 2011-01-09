Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1AIUVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 15:21:06 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:47158 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1AIUVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 15:21:04 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAKnKU2rR7H+/2dsb2JhbACkPnOjYpcghUwEhGeGI4Mg
Message-ID: <4D2A18AD.6020406@cisco.com>
Date: Sun, 09 Jan 2011 13:21:01 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf stat: fix scale option
References: <1294595425-16791-1-git-send-email-daahern@cisco.com> <20110109194919.GC28554@elte.hu>
In-Reply-To: <20110109194919.GC28554@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/11 12:49, Ingo Molnar wrote:
> 
> * David Ahern <daahern@cisco.com> wrote:
> 
>> The scale option defaults to true and the command line option only
>> allows it to be set to true. ie. the option is a no-op.
> 
> Hm, the option parser should already allow --no-scale. Does that not work for you?
> 
> Thanks,
> 
> 	Ingo

Indeed it does work; I was not aware of that option. What about the '-c'
option being a no-op?

David
