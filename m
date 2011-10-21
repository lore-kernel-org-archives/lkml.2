Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab1JUDTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 23:19:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48119 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1JUDTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 23:19:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Oct 2011 12:17:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
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
Message-Id: <20111021121759.429d8222.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111021024554.GC2589@tiehlicka.suse.cz>
References: <20111020013305.GD21703@tiehlicka.suse.cz>
	<CALWz4ixxeFveibvqYa4cQR1a4fEBrTrTUFwm2iajk9mV0MEiTw@mail.gmail.com>
	<20111021024554.GC2589@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Oct 2011 19:45:55 -0700
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 20-10-11 16:41:27, Ying Han wrote:
> [...]
> > Hi Michal:
> 
> Hi,
> 
> > 
> > I didn't read through the patch itself but only the description. If we
> > wanna protect a memcg being reclaimed from under global memory
> > pressure, I think we can approach it by making change on soft_limit
> > reclaim.
> > 
> > I have a soft_limit change built on top of Johannes's patchset, which
> > does basically soft_limit aware reclaim under global memory pressure.
> 
> Is there any link to the patch(es)? I would be interested to look at
> it before we discuss it.
> 

I'd like to see it, too.

Thanks,
-Kame

