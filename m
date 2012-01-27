Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2A0UGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:06:53 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56535 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511Ab2A0UGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:06:51 -0500
Message-ID: <4F2303D8.80300@rgmadvisors.com>
Date: Fri, 27 Jan 2012 14:06:48 -0600
From: Andrew Steets <asteets@rgmadvisors.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
References: <4F22D8D9.3010108@rgmadvisors.com> <1327684363.2446.176.camel@twins>
In-Reply-To: <1327684363.2446.176.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/12 11:12 AM, Peter Zijlstra wrote:
> On Fri, 2012-01-27 at 11:03 -0600, Andrew Steets wrote:
>> Can anyone tell
>> me if I'm using this wrong or if this is a bug?
>
> You're using it wrong, it will disable events you own (created) not
> events that monitor you.

Is there an alternate way of disabling events that monitor the current
process?  I ask because I came across the following description in
tools/perf/design.txt:

     A process can enable or disable all the counter groups that are
     attached to it, using prctl:

         prctl(PR_TASK_PERF_EVENTS_ENABLE);

         prctl(PR_TASK_PERF_EVENTS_DISABLE);

     This applies to all counters on the current process, whether created
     by this process or by another, and doesn't affect any counters that
     this process has created on other processes.  It only enables or
     disables the group leaders, not any other members in the groups.

-Andrew

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
