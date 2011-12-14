Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab1LNSTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:19:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35216 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab1LNSTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:19:00 -0500
Date: Wed, 14 Dec 2011 10:18:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, cgroups@vger.kernel.org,
        bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 2/3] make clone_children a flag
Message-ID: <20111214181852.GB20380@google.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com>
 <1323614738-7405-4-git-send-email-glommer@parallels.com>
 <20111213153921.GE25802@google.com>
 <4EE80A0D.7090808@cn.fujitsu.com>
 <4EE84B9A.90901@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE84B9A.90901@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 14, 2011 at 11:09:14AM +0400, Glauber Costa wrote:
> That's indeed confusing, and it comes from the fact that we always
> inherit clone_children from the parent - which is sane, IMHO. So
> this flag only has any value in establishing the initial behaviour
> of the top root cgroup. I wonder then if it wouldn't better to just
> be explicit and fail in this case ?

I don't think all current behaviors are sane and if not let's change
them, but those things have to be explicit with proper description and
rationale.

Thanks.

-- 
tejun
