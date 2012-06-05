Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2FEXst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:48:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47704 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab2FEXsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:48:47 -0400
Message-ID: <4FCE9ADB.9000405@gmail.com>
Date: Tue, 05 Jun 2012 17:48:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: git bisect and perf
References: <4FCE25C6.2080601@gmail.com> <1338912052.2749.2.camel@twins>  <1338912312.2749.6.camel@twins> <4FCE3DE3.9060805@gmail.com> <1338917712.2749.24.camel@twins>
In-Reply-To: <1338917712.2749.24.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the explanation and patience.

On 6/5/12 11:35 AM, Peter Zijlstra wrote:
> Now not all events the Intel PMU can do are PEBS capable; in fact most
> aren't. So the whole cycles thing is about mapping the regular cycles
> event to something that is PEBS capable.
>


I think I get it now. 7639dae0 is the commit I needed. With it 2.6.35.14 
can do cycles:pp profiling.

In general only the events listed in intel_XXXXX_pebs_events can be used 
with :p.

David

