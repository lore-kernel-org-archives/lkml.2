Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab2JaR0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:26:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37606 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2JaR0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:26:22 -0400
Date: Wed, 31 Oct 2012 10:26:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] cgroup: simplify cgroup removal path
Message-ID: <20121031172617.GK2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <50912C6D.6020000@parallels.com>
 <20121031171849.GH2945@htj.dyndns.org>
 <50915EB6.3060704@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50915EB6.3060704@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 09:24:06PM +0400, Glauber Costa wrote:
> > Note both in the commit messages.
> 
> I am sorry, but I can't find anything that may be related to this in the
> commit messages. Can you be more specific ?

Eh.. 'd', missing there.  I meant that I noted both in the updated
commit messages, so they will be mentioned in commit messages on the
next posting of this series.

Thanks.

-- 
tejun
