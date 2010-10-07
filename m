Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab0JGB4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:56:42 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52515 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab0JGB4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 21:56:40 -0400
X-AuditID: b753bd60-aa6d3ba000005dcc-3c-4cad28d36c42
Message-ID: <4CAD28C6.3090305@hitachi.com>
Date: Thu, 07 Oct 2010 10:56:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        ddaney@caviumnetworks.com, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/5] jump label: fix module __init section race
References: <cover.1285965957.git.jbaron@redhat.com>	 <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com>	 <4CA6F44A.1000907@hitachi.com>	 <1286370051.6750.180.camel@gandalf.stny.rr.com>	 <20101006154140.GA2941@redhat.com> <1286379974.6661.0.camel@gandalf.stny.rr.com>
In-Reply-To: <1286379974.6661.0.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/07 0:46), Steven Rostedt wrote:
> On Wed, 2010-10-06 at 11:41 -0400, Jason Baron wrote:
>> On Wed, Oct 06, 2010 at 09:00:50AM -0400, Steven Rostedt wrote:
>>> On Sat, 2010-10-02 at 17:58 +0900, Masami Hiramatsu wrote:
>>>
>>>>> +static void remove_module_init(struct module *mod)
>>>>
>>>> Hi Jason,
>>>>
>>>> Just a comment, I prefer remove_jump_label_module_init() than this name,
>>>> because remove_module_init is too general.
>>>
>>> This is probably not too big of a deal since it is static, but the name
>>> change may make it easier for etags and ctags users.
>>>
>>> Jason, are you OK if I pull in this patch and make the change myself?
>>>
>>> -- Steve
>>>
>>
>> fine with me. I had a more specific function name and then shortened it
>> because it seemed too long, either way is fine with me.
>>
> 
> Maybe call it jl_remove_module_init()?  For static functions, I usually
> use abbreviations. As long as it isn't too confusing.
> 

Ah, that's fine for me too :)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
