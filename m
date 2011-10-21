Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1JUQLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:11:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41075 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1JUQLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:11:44 -0400
MIME-Version: 1.0
In-Reply-To: <20111020105950.fd04f58f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111020013305.GD21703@tiehlicka.suse.cz>
	<20111020105950.fd04f58f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 21 Oct 2011 21:41:43 +0530
Message-ID: <CAKTCnz=0VcM9zi2Apv0YOrYPRqe6Cmm_QDcBj5t2nMo1=f9+Og@mail.gmail.com>
Subject: Re: [RFD] Isolated memory cgroups again
From: Balbir Singh <bsingharora@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelianov <xemul@parallels.com>, GregThelen <gthelen@google.com>,
        "pjt@google.com" <pjt@google.com>, Tim Hockin <thockin@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But I personally think we should make softlimit better rather than
> adding new interface. If this feature can be archieved when setting
> softlimit=UNLIMITED, it's simple. And Johannes' work will make this
> easy to be implemented.
> (total rewrite of softlimit should be required...I think.)
>

Yeah.. I'd be open to a rewrite if we get the specification/design
right. I did soft limits in a few months and tested it on workloads
till I was satisfied it worked.

Balbir Singh
