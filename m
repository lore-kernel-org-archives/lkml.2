Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2EYNet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:34:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab2EYNep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:34:45 -0400
Date: Fri, 25 May 2012 15:34:41 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 00/28] kmem limitation for memcg
Message-ID: <20120525133441.GB30527@tiehlicka.suse.cz>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337951028-3427-1-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-05-12 17:03:20, Glauber Costa wrote:
> I believe some of the early patches here are already in some trees around.
> I don't know who should pick this, so if everyone agrees with what's in here,
> please just ack them and tell me which tree I should aim for (-mm? Hocko's?)
> and I'll rebase it.

memcg-devel tree is only to make development easier. Everything that
applies on top of this tree should be applicable to both -mm and
linux-next.
So the patches should go via traditional Andrew's channel.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
