Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2A1XsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 18:48:12 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:37527 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614Ab2A1XsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 18:48:11 -0500
Message-ID: <4F248938.5030507@rgmadvisors.com>
Date: Sat, 28 Jan 2012 17:48:08 -0600
From: Andrew Steets <asteets@rgmadvisors.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
References: <4F22D8D9.3010108@rgmadvisors.com> <20120128120151.GA10390@elte.hu>
In-Reply-To: <20120128120151.GA10390@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/12 6:01 AM, Ingo Molnar wrote:

>> prctl(PR_TASK_PERF_EVENTS_DISABLE) doesn't appear to disable
>> perf event counters.  Here is a demonstration program:
>
> btw., what's your usecase?
>

I'm trying to profile a small section of a long-running program.  I ran
into trouble using call-graph recording and I thought this might be an
alternative way of getting what I was after.

-Andrew

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
