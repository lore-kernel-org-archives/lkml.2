Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2FKSnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:43:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:59962 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab2FKSnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="151502736"
Message-ID: <4FD63C52.4090003@linux.intel.com>
Date: Mon, 11 Jun 2012 11:43:30 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Tim Chen <tim.c.chen@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Does perf inject preserve call chain data?
References: <1337712585.3796.186.camel@schen9-DESK> <4FBC0C10.8010801@gmail.com> <20120608143843.GA9954@infradead.org> <1339173896.3796.230.camel@schen9-DESK> <4FD232B7.7080905@gmail.com> <1339175828.3796.232.camel@schen9-DESK> <20120608195215.GO28225@tassilo.jf.intel.com> <20120609160547.GB9954@infradead.org>
In-Reply-To: <20120609160547.GB9954@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> # perf top -a -G sleep 5
>
> Where it would figure out that since a workload was specified, it should
> just not be refreshing the screen every N seconds but wait till the
> workload to finish and then present the results, without setting up any
> perf.data files.

But top does not generate email'able ASCII format like perf report does, 
doesn't it?



-Andi


