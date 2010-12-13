Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0LMTPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:15:19 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:9331 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0LMTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:15:17 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIP/BU2rR7H+/2dsb2JhbACkCXioD5suhUoEhGSGFYMU
X-IronPort-AV: E=Sophos;i="4.59,337,1288569600"; 
   d="scan'208";a="231881368"
Message-ID: <4D0670BF.6050403@cisco.com>
Date: Mon, 13 Dec 2010 12:15:11 -0700
From: "David S. Ahern" <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
References: <20101213170923.GB1691@nowhere> <1292260289.6803.297.camel@twins> <20101213171537.GC1691@nowhere> <1292260699.6803.305.camel@twins> <20101213172216.GB7417@ghostprotocols.net> <1292261716.6803.332.camel@twins> <1292262433.6803.351.camel@twins> <4D065CB2.7050104@cisco.com> <1292263024.6803.370.camel@twins> <4D065F69.7080707@cisco.com> <20101213190831.GA7984@ghostprotocols.net>
In-Reply-To: <20101213190831.GA7984@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We have:
> 
> [acme@mica linux]$ perf list | grep -- -clock
>   cpu-clock                                  [Software event]
>   task-clock                                 [Software event]
> [acme@mica linux]$ 
> 
> So we would have a new one:
> 
>   monotonic-clock

Name seems off. The 'event' is to grab time-of-day and have the 'time'
attribute set which gives the correlation between wall-clock and perf
timestamps.

David

> 
> Peter, agreed? I'll try to implement it now, good opportunity to learn a
> bit more about soft pmus, I'd have to do that anyway for NIC stats, etc.
> 
> - Arnaldo
