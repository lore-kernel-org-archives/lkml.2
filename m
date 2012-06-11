Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab2FKTL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:11:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2FKTLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:11:55 -0400
Message-ID: <4FD642F7.3060201@gmail.com>
Date: Mon, 11 Jun 2012 13:11:51 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Does perf inject preserve call chain data?
References: <1337712585.3796.186.camel@schen9-DESK> <4FBC0C10.8010801@gmail.com> <20120608143843.GA9954@infradead.org> <1339173896.3796.230.camel@schen9-DESK> <4FD232B7.7080905@gmail.com> <1339175828.3796.232.camel@schen9-DESK> <20120608195215.GO28225@tassilo.jf.intel.com> <20120609160547.GB9954@infradead.org> <4FD63C52.4090003@linux.intel.com>
In-Reply-To: <4FD63C52.4090003@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/12 12:43 PM, Andi Kleen wrote:
>
>
>> # perf top -a -G sleep 5
>>
>> Where it would figure out that since a workload was specified, it should
>> just not be refreshing the screen every N seconds but wait till the
>> workload to finish and then present the results, without setting up any
>> perf.data files.
>
> But top does not generate email'able ASCII format like perf report does,
> doesn't it?


perf top --stdio ...

