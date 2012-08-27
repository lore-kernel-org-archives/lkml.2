Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2H0V43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:56:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52203 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2H0V41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:56:27 -0400
Message-ID: <503BED07.9030404@gmail.com>
Date: Mon, 27 Aug 2012 15:56:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] perf: teach perf inject to merge sched_stat_* and
 sched_switch events (v2)
References: <1344344165-369636-1-git-send-email-avagin@openvz.org> <1344344165-369636-4-git-send-email-avagin@openvz.org> <m2ehms6ouh.fsf@firstfloor.org>
In-Reply-To: <m2ehms6ouh.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/12 2:51 PM, Andi Kleen wrote:
> Andrew Vagin <avagin@openvz.org> writes:
>>
>> My code saves sched_switch event for each process and when it meets
>> stat_iowait, it reports the sched_switch event, because this event
>> contains a correct callchain. By another words it replaces all
>> stat_iowait events on proper sched_switch events.
>
> Is there any way to generalize this to arbitary events? I found myself
> writing scripts to compute lengths between various events.  But I

You mean delta-time between events? I have toyed around with patches to 
perf-script for this -- dt between same event on a cpu, dt between 
consecutive events on a cpu, dt between events for a thread, etc.

David


