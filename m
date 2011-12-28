Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1L1Qgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:36:38 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41835 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026Ab1L1Qgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:36:37 -0500
Date: Wed, 28 Dec 2011 08:36:31 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Message-ID: <20111228163631.GN17712@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
 <20111227163535.GA17712@google.com>
 <4EFAB2E2.4040008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFAB2E2.4040008@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Dec 28, 2011 at 02:10:42PM +0800, Li Zefan wrote:
> The "name" option was introduced along with the "none" option, so we
> can distinguish between different cgroup hierarchies which have no
> bound subsystems, like this:
> 
> 	# mount -t cgroup -o none,name=hier1 xxx /cgroup1
> 	# mount -t cgroup -o none,name=hier2 xxx /cgroup2
> 
> As the name is unique, we have this "mount by hierarchy name" feature.

I could be missing something but does that add anything other than
naming convenience?

> It looks reasonable, but I guess few people know this feature. We can
> live with it, as it only saves us some typing when mounting an existing
> hierarchy. On the other hand, removing this small feature can hardly
> result in code reduction.

If it's a redundant feature which has been broken over a year without
anyone complaining, it really doesn't need to exist.  It might not
save a lot of code but would save some WTH moments.

Thanks.

-- 
tejun
