Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1JUCqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 22:46:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab1JUCqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 22:46:06 -0400
Date: Thu, 20 Oct 2011 19:45:55 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelianov <xemul@parallels.com>, GregThelen <gthelen@google.com>,
        "pjt@google.com" <pjt@google.com>, Tim Hockin <thockin@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [RFD] Isolated memory cgroups again
Message-ID: <20111021024554.GC2589@tiehlicka.suse.cz>
References: <20111020013305.GD21703@tiehlicka.suse.cz>
 <CALWz4ixxeFveibvqYa4cQR1a4fEBrTrTUFwm2iajk9mV0MEiTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALWz4ixxeFveibvqYa4cQR1a4fEBrTrTUFwm2iajk9mV0MEiTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-10-11 16:41:27, Ying Han wrote:
[...]
> Hi Michal:

Hi,

> 
> I didn't read through the patch itself but only the description. If we
> wanna protect a memcg being reclaimed from under global memory
> pressure, I think we can approach it by making change on soft_limit
> reclaim.
> 
> I have a soft_limit change built on top of Johannes's patchset, which
> does basically soft_limit aware reclaim under global memory pressure.

Is there any link to the patch(es)? I would be interested to look at
it before we discuss it.

[...]

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
