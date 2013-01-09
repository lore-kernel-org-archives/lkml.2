Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3AINnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:43:45 -0500
Received: from mx2.parallels.com ([64.131.90.16]:60182 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436Ab3AINnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:43:43 -0500
Message-ID: <50ED7411.50000@parallels.com>
Date: Wed, 9 Jan 2013 17:43:45 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>
Subject: Re: [PATCH 1/2] Add mempressure cgroup
References: <20130104082751.GA22227@lizard.gateway.2wire.net> <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org> <50ED30CE.8070208@parallels.com> <20130109011512.a87ffdfa.akpm@linux-foundation.org>
In-Reply-To: <20130109011512.a87ffdfa.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:15 PM, Andrew Morton wrote:
> On Wed, 9 Jan 2013 12:56:46 +0400 Glauber Costa <glommer@parallels.com> wrote:
> 
>>> +#if IS_SUBSYS_ENABLED(CONFIG_CGROUP_MEMPRESSURE)
>>> +SUBSYS(mpc_cgroup)
>>> +#endif
>>
>> It might be just me, but if one does not know what this is about, "mpc"
>> immediately fetches something communication-related to mind. I would
>> suggest changing this to just plain "mempressure_cgroup", or something
>> more descriptive.
> 
> mempressure_cgroup is rather lengthy.  "mpcg" would be good - it's short
> and rememberable.
> 
Or, since most of the cgroups don't actually use the suffix "cgroup"
(with the exception of cpu and memcg), maybe just mempressure?


