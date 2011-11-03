Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab1KCRuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:50:46 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49391 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174Ab1KCRup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:50:45 -0400
Message-ID: <4EB2D451.4010607@parallels.com>
Date: Thu, 3 Nov 2011 15:50:09 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Max Kellermann <mk@cm4all.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tim Hockin <thockin@hockin.org>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] new cgroup controller "fork"
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag> <20111103164302.GE8198@somewhere.redhat.com> <20111103171645.GA27887@rabbit.intern.cm-ag> <4EB2CEB2.7050800@parallels.com> <20111103174809.GA28108@rabbit.intern.cm-ag>
In-Reply-To: <20111103174809.GA28108@rabbit.intern.cm-ag>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 03:48 PM, Max Kellermann wrote:
> On 2011/11/03 18:26, Glauber Costa<glommer@parallels.com>  wrote:
>> On 11/03/2011 03:16 PM, Max Kellermann wrote:
>>> but is different from my controller.
>>>
>> How so?
>
> Once the "remaining" counter has reached zero, no further forks are
> possible, no matter how many processes are left.  It is a fork
> counter, not a process counter.
>
> Let's say: Frederic's controller counts "things" that exists
> (processes), and my controller counts "verbs" or "ations" (fork()).
>
> Max
That still seems to be up to admin. If no processes are removed from the 
cgroup or included in the cgroup, the only action/verb the counter
is concerned about is to fork. Under this circumstance, both seem 
equivalent from my PoV.
