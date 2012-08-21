Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab2HUVtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 17:49:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482Ab2HUVtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 17:49:00 -0400
Date: Tue, 21 Aug 2012 14:48:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Lennart Poettering <lpoetter@redhat.com>
Cc: aris@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Message-ID: <20120821214856.GC32596@google.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174454.087507415@napanee.usersys.redhat.com>
 <20120816200006.GG24861@google.com>
 <50340110.50607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50340110.50607@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 21, 2012 at 11:43:44PM +0200, Lennart Poettering wrote:
> >I'm not against this but unsure whether using kmem is enough for the
> >suggested use case.  Lennart, would this suit systemd?  How much
> >metadata are we talking about?
> 
> Just small things, like values, PIDs, i.e. a few 100 bytes or so per
> cgroup should be more than sufficient for our needs.

Alright, then.  I think there's gonna be one more round to address
Hugh's comments.  Hugh, how should this be routed?  Is there some git
branch that tmpfs changes can go in so that cgroup tree can pull?

Thanks.

-- 
tejun
