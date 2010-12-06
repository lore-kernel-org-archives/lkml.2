Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0LFB01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 20:26:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49676 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab0LFB00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 20:26:26 -0500
Message-ID: <4CFC3C24.5010407@cn.fujitsu.com>
Date: Mon, 06 Dec 2010 09:28:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Subject: Re: [PATCH 06/15] ftrace: fix event alignment: module:module_request
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>	 <1291421609-14665-7-git-send-email-dhsharp@google.com> <1291427265.16223.8.camel@gandalf.stny.rr.com>
In-Reply-To: <1291427265.16223.8.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-06 09:26:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-06 09:26:32,
	Serialize complete at 2010-12-06 09:26:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> [ Ccing Li for an Acked-by. He wrote this event ]
> 
> -- Steve
> 
> 
> On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
>> Signed-off-by: David Sharp <dhsharp@google.com>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

>> ---
>>  include/trace/events/module.h |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/trace/events/module.h b/include/trace/events/module.h
>> index c7bb2f0..8154f5f 100644
>> --- a/include/trace/events/module.h
>> +++ b/include/trace/events/module.h
>> @@ -98,14 +98,14 @@ TRACE_EVENT(module_request,
>>  	TP_ARGS(name, wait, ip),
>>  
>>  	TP_STRUCT__entry(
>> -		__field(	bool,		wait		)
>>  		__field(	unsigned long,	ip		)
>> +		__field(	bool,		wait		)
>>  		__string(	name,		name		)
>>  	),
>>  
>>  	TP_fast_assign(
>> -		__entry->wait	= wait;
>>  		__entry->ip	= ip;
>> +		__entry->wait	= wait;
>>  		__assign_str(name, name);
>>  	),
>>  
>> @@ -119,4 +119,3 @@ TRACE_EVENT(module_request,
>>  
>>  /* This part must be outside protection */
>>  #include <trace/define_trace.h>
>> -
> 
> 
> 
