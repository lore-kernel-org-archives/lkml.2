Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1LWKI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:08:57 -0500
Received: from mx2.parallels.com ([64.131.90.16]:47435 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509Ab1LWKIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:08:55 -0500
Message-ID: <4EF45309.7060005@parallels.com>
Date: Fri, 23 Dec 2011 14:08:09 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>, <pjt@google.com>,
        <devel@openvz.org>, Michal Hocko <mhocko@suse.cz>,
        Dave Jones <davej@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] move get_idle_time , get_iowait_time to sched/core.c
References: <1323682263-1310-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1323682263-1310-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 01:31 PM, Glauber Costa wrote:
> In commit a25cac5198 we changed the way we calculate idle and iowait
> for /proc/stat displaying purposes. However, this same information
> is also displayed in /proc/uptime. These values can now be inconsistent.
>
> So I propose we draw both idle values from the same place. In theory,
> we only need to do it for get_idle_time(). get_iowait_time() is moved
> as well for consistency only.
>
> I moved the functions to sched/core.c so it can live among its other
> friends like nr_iowait(), etc.
>

You guys have any opinions on this ?
I see that Michal got another fix for this in stat.c already, so I'd 
have to respin this one anyway. Just let me know if this is wanted

Thanks
