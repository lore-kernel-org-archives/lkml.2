Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1DXNqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 09:46:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49320 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1DXNp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 09:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hA/0bXEGoM/OxgMVBmIn4/fjxeX3hNOVer78veO2ZiNQlZgXJLCWJ0p2ifXIOVJIH+
         EOYsFuwTFshgQt66ZUgKyLWqtqrVbcubVFwJxYXNZetfCKJmrXE/5OnBChnevbEMyQBG
         EZk6VMWQrTC5dc8Xr4edcIlITP1TCVEoahqfY=
Message-ID: <4DB42988.7060607@gmail.com>
Date: Sun, 24 Apr 2011 07:45:44 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>, Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.39-rc2] perf top fails to mmap - bisected to 70db7533
References: <inhgjs$54a$1@dough.gmane.org> <BANLkTikWpnnHAfO2n2rN6ExtQyrsVaiqEQ@mail.gmail.com> <1303570271.3363.4.camel@localhost> <201104241347.52486.tim@klingt.org>
In-Reply-To: <201104241347.52486.tim@klingt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/24/11 05:47, Tim Blechmann wrote:
>>>> I know you've been busy with other stuff the past few weeks, but have
>>>> you had a chance to look into this? Basically, perf in 2.6.39 is broken
>>>> when trying to profile a process (-p argument to record or top).
>>>
>>> Let me take a look at this.
>>
>> Below patch fixes the same problem on my box.
>> Could you have a try it?
> 
> i have done some quick tests with this patch applied on linus/master ... works 
> fine for me, thanks a lot!

Works for me as well.

> 
>> >From 89f1ab02cd8da55f8829b2f2d7e700fdae77b3af Mon Sep 17 00:00:00 2001
>>
>> From: Lin Ming <ming.m.lin@intel.com>
>> Date: Sat, 23 Apr 2011 14:54:33 +0000
>> Subject: [PATCH] perf: Allow set output event for task in the same thread
>> group
>>
>> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> 
> Tested-by: Tim Blechmann <tim@klingt.org>
> 
> cheers, tim
> 
