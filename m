Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab3AIWKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:10:20 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64163 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3AIWKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:10:18 -0500
Date: Wed, 9 Jan 2013 14:06:41 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] Add mempressure cgroup
Message-ID: <20130109220641.GA12865@lizard.fhda.edu>
References: <20130104082751.GA22227@lizard.gateway.2wire.net>
 <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
 <20130109203731.GA20454@htj.dyndns.org>
 <50EDDF1E.6010705@parallels.com>
 <20130109213604.GA9475@lizard.fhda.edu>
 <20130109215514.GD20454@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130109215514.GD20454@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 01:55:14PM -0800, Tejun Heo wrote:
[...]
> > We can use mempressure w/o memcg, and even then it can (or should :) be
> > useful (for cpuset, for example).
> 
> The problem is that you end with, at the very least, duplicate
> hierarchical accounting mechanisms which overlap with each other
> while, most likely, being slightly different.  About the same thing
> happened with cpu and cpuacct controllers and we're now trying to
> deprecate the latter.

Yeah. I started answering your comments about hierarchical accounting,
looked into the memcg code, and realized that *this* is where I need the
memcg stuff. :)

Thus yes, I guess I'll have to integrate it with memcg, or sort of.

I will surely Cc you on the next interations.

Thanks,
Anton
