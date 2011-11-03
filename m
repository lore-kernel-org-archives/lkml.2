Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab1KCR0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:26:46 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60135 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab1KCR0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:26:45 -0400
Message-ID: <4EB2CEB2.7050800@parallels.com>
Date: Thu, 3 Nov 2011 15:26:10 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Max Kellermann <mk@cm4all.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tim Hockin <thockin@hockin.org>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] new cgroup controller "fork"
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag> <20111103164302.GE8198@somewhere.redhat.com> <20111103171645.GA27887@rabbit.intern.cm-ag>
In-Reply-To: <20111103171645.GA27887@rabbit.intern.cm-ag>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2011 03:16 PM, Max Kellermann wrote:
> On 2011/11/03 17:43, Frederic Weisbecker<fweisbec@gmail.com>  wrote:
>> Please have a look at the task counter subsystem: https://lwn.net/Articles/461462/
>>
>> It's in the -mm tree. I'm glad to hear about another user who wants
>> this feature in cgroups. We need to hear about you and whether this
>> meets your requirements in order to get it merged upstream.
>
> Had a quick look at your patch set.  No, it does not seem to meet my
> requirements.  It limits the number of processes in a cgroup - that is
> also very useful, but is different from my controller.
>
How so?
If you never move tasks to a cgroup except at setup time - which is the 
common case for almost everybody, I imagine, you end up achieving the 
same thing.
