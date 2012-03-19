Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030835Ab2CSQFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:05:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37392 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab2CSQFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:05:38 -0400
Date: Mon, 19 Mar 2012 09:05:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com
Subject: Re: [PATCHSET] cgroup: cftype based file interface
Message-ID: <20120319160532.GB11069@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <4F6708F4.4000604@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6708F4.4000604@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Mon, Mar 19, 2012 at 02:22:44PM +0400, Glauber Costa wrote:
> >Glauber, can you please try to move net kmem stuff out of
> >->populate().  If ->create() doesn't work for whatever reason, can you
> >please explain it to me so that we can find a proper solution?
> 
> The main reason is twofold:
> 
> It first had to do with the order in which registerings take place
> at the kernel. But this matter most for the root cgroup. For the
> children, it should be all initialized anyway. So we can special
> case whatever is needed.

I see.

> Another point was not to bloat the socket structures with more
> function calls, for populate and create. But we can possibly be able
> to store some data ourselves, and figure it out.
>
> How should I do it? Do you want me to provide a patch ontop of your tree ?

Yeah, that would be great.

Thanks.

-- 
tejun
