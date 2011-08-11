Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1HKI0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:26:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1HKI0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:26:43 -0400
Date: Thu, 11 Aug 2011 10:26:41 +0200
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
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2][cleanup] memcg: renaming of mem variable to memcg
Message-ID: <20110811082641.GD8023@tiehlicka.suse.cz>
References: <20110810172917.23280.9440.sendpatchset@oc5400248562.ibm.com>
 <20110811075337.GA8023@tiehlicka.suse.cz>
 <4E438FD3.7070000@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E438FD3.7070000@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-08-11 13:46:19, Raghavendra K T wrote:
> On 08/11/2011 01:23 PM, Michal Hocko wrote:
> >On Wed 10-08-11 22:59:17, Raghavendra K T wrote:
> >>Hi,
> >>  This is the memcg cleanup patch for that was talked little ago to change the  "struct
> >>  mem_cgroup *mem" variable to  "struct mem_cgroup *memcg".
> >>
> >>  The patch is though trivial, it is huge one.
> >>  Testing : Compile tested with following configurations.
> >>  1) CONFIG_CGROUP_MEM_RES_CTLR=y  CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
> >>  2) CONFIG_CGROUP_MEM_RES_CTLR=y  CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n
> >>  3) CONFIG_CGROUP_MEM_RES_CTLR=n  CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n
> >
> >How exactly have you tested? Compiled and compared before/after binaries
> >(it shouldn't change, right)?
> Yes, But idea was to ensure that both #ifdef and #else part are hit
> during compilation, which could expose some corrections needed.

I am not sure I understand. You have used different combinations of
configuration to trigger all #ifdefs but that doesn't change anything on
the fact that the code should be exactly same before and after your
patch, right?

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
