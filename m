Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1KZUSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:18:12 -0500
Received: from mx2.parallels.com ([64.131.90.16]:34088 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab1KZUSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:18:11 -0500
Message-ID: <4ED1495D.1090500@parallels.com>
Date: Sat, 26 Nov 2011 18:17:33 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: <linux-kernel@vger.kernel.org>, <lizf@cn.fujitsu.com>,
        <daniel.lezcano@free.fr>, <a.p.zijlstra@chello.nl>,
        <jbottomley@parallels.com>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH 3/4] Move part of cpuacct code
References: <1322184806-20421-1-git-send-email-glommer@parallels.com> <1322184806-20421-4-git-send-email-glommer@parallels.com> <CAPM31RJoN2t+nUuap+FWLYoEx=EshU=v6Gy8JsxJAaichZFjcA@mail.gmail.com>
In-Reply-To: <CAPM31RJoN2t+nUuap+FWLYoEx=EshU=v6Gy8JsxJAaichZFjcA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2011 11:21 AM, Paul Turner wrote:
> On Thu, Nov 24, 2011 at 5:33 PM, Glauber Costa<glommer@parallels.com>  wrote:
>> This patch is just a preparation patch for the next one in the series.
>> It moves the cpuacct structure definition and some helper functions early
>> in the file so we can access its members from here on.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Paul Tuner<pjt@google.com>
>> CC: Peter Zijlstra<a.p.zijlstra@chello.nl>
>> ---
>>   kernel/sched.c |   77 +++++++++++++++++++++++++++----------------------------
>>   1 files changed, 38 insertions(+), 39 deletions(-)
>
> Bad news -- You've run afoul of a massive file re-structuring conflict :(
>
> All of sched has been refactored under "kernel/sched/"; sched.c and
> friends don't exist anymore.
>
> - Paul

can you tell me where this lives? This does not seem to be the case in 
any of my git trees here (just fetched, including your sched.git/master 
at kernel.org)

