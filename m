Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1LTO5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:57:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46630 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1LTO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:57:01 -0500
Date: Tue, 20 Dec 2011 18:56:54 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Android low memory killer vs. memory pressure notifications
Message-ID: <20111220145654.GA26881@oksana.dev.rtsoft.ru>
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru>
 <20111219121255.GA2086@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1112191110060.19949@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112191110060.19949@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 11:12:09AM -0800, David Rientjes wrote:
> On Mon, 19 Dec 2011, Michal Hocko wrote:
> 
> > page_cgroup is 16B per page and with the current Johannes' memcg
> > naturalization work (in the mmotm tree) we are down to 8B per page (we
> > got rid of lru). Kamezawa has some patches to get rid of the flags so we
> > will be down to 4B per page on 32b. Is this still too much?
> > I would be really careful about a yet another lowmem notification
> > mechanism.
> > 
> 
> There was always general interest in a low memory notification mechanism 
> even prior to memcg, see http://lwn.net/Articles/268732/ from Marcelo and 
> KOSAKI-san.  The desire is not only to avoid the metadata overhead of 
> memcg, but also to avoid cgroups entirely.

Hm, assuming that metadata is no longer an issue, why do you think avoiding
cgroups would be a good idea?

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
