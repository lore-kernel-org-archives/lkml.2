Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1ALTmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:42:03 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55284 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab1ALTmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:42:01 -0500
Message-ID: <4D2E0403.7080300@linux.vnet.ibm.com>
Date: Wed, 12 Jan 2011 11:41:55 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmU=?= =?UTF-8?B?Y2tlcg==?= 
	<fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [BUG] perf sched broken
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
In-Reply-To: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 01:29 AM, Stephane Eranian wrote:
> Hi,
>
> I am trying to use perf sched from tip-x86 but it fails for all my attempts.

So far I have been unsuccessful in reproducing this problem, but I 
suspect that I have the wrong git tree or branch.  The git tree I've 
cloned is:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

I've tried the branches master, x86/urgent, and x86-urgent-for-linus. 
All of those produce correct results, as far as I can tell.

Which tree / branch should I be using?

- Corey
