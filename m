Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2JPHDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:03:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab2JPHDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:03:06 -0400
Date: Tue, 16 Oct 2012 09:03:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Sha Zhengju <handai.szj@taobao.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Message-ID: <20121016070302.GA13991@dhcp22.suse.cz>
References: <1350367837-27919-1-git-send-email-handai.szj@taobao.com>
 <alpine.DEB.2.00.1210152311460.9480@chino.kir.corp.google.com>
 <507CFF65.7050109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507CFF65.7050109@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-10-12 14:32:05, Sha Zhengju wrote:
[...]
> Thanks for reminding!  Yes, I cooked it on memcg-devel git repo but
> a out-of-date
> since-3.2 branch... But I notice the latest branch is since-3.5(not
> seeing 3.6/3.7), does
> it okay to working on this branch?

The tree has moved to
http://git.kernel.org/?p=linux/kernel/git/mhocko/mm.git;a=summary.
Please use that tree.
-- 
Michal Hocko
SUSE Labs
