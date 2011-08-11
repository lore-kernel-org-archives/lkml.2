Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1HKJDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:03:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab1HKJDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:03:22 -0400
Date: Thu, 11 Aug 2011 11:03:18 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Raghavendra K T <raghukt@linux.vnet.ibm.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2][cleanup] memcg: renaming of mem variable to memcg
Message-ID: <20110811090318.GE8023@tiehlicka.suse.cz>
References: <20110810172917.23280.9440.sendpatchset@oc5400248562.ibm.com>
 <20110810172929.23280.76419.sendpatchset@oc5400248562.ibm.com>
 <20110811080447.GB8023@tiehlicka.suse.cz>
 <4E439962.4040105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E439962.4040105@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-08-11 14:27:06, Raghavendra K T wrote:
> On 08/11/2011 01:34 PM, Michal Hocko wrote:
> >On Wed 10-08-11 22:59:29, Raghavendra K T wrote:
> >[...]
> >>This patch renames all mem variables to memcg in source file.
> >
> >__mem_cgroup_try_charge for example uses local mem which cannot be
> >renamed because it already has a memcg argument (mem_cgroup **) then we
> >have mem_cgroup_try_charge_swapin and mem_cgroup_prepare_migration which
> >use mem_cgroup **ptr (I guess we shouldn't have more of them).
> >I think that __mem_cgroup_try_charge should use ptr pattern as well.
> >Other than that I think the clean up is good.
> >
> >With __mem_cgroup_try_charge:
> >Acked-by: Michal Hocko<mhocko@suse.cz>
> >
> >Thanks
> Agreed, Let me know whether you prefer whole patch to be posted or
> only the corresponding hunk.

I would go with the full (single) patch. I would also recommend to add
results of your tests into the changelog (which configurantion have been
tested and how did you test binary compatibility).

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
