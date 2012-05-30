Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2E3MKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:10:43 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54729 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab2E3MKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:10:42 -0400
Message-ID: <4FC60DB8.70405@parallels.com>
Date: Wed, 30 May 2012 16:08:24 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        <handai.szj@gmail.com>, <Andrew.Phillips@lmax.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 4/6] add a new scheduler hook for context switch
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>  <1338371317-5980-5-git-send-email-glommer@parallels.com>  <1338376851.26856.260.camel@twins> <1338378051.26856.267.camel@twins>
In-Reply-To: <1338378051.26856.267.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 03:40 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 13:20 +0200, Peter Zijlstra wrote:
>>
>> $ perf stat -e cycles --repeat 100 perf bench sched messaging -p -g 100
>>
>>      48,826,146,710 cycles  #    2.470 GHz  ( +-  0.17% )
>>         2.149005270 seconds time elapsed    ( +-  0.12% )
>
> A repeat count of 250 dropped it down to:
>
>          2.144582157 seconds time elapsed    ( +-  0.08% )
>
> Also, if you're poking at the context switch path, something like:
>
> $ taskset 1 perf stat -e cycles --repeat 10 perf bench sched pipe -l 100000
>
> gives a good number and is usually more stable than hackbench.
thanks for the pointers

