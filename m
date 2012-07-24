Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2GXS2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:28:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59702 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab2GXS2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:28:15 -0400
Date: Tue, 24 Jul 2012 11:28:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: Hugh Dickins <hughd@google.com>, Aristeu Rozanski <aris@redhat.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
Message-ID: <20120724182809.GD5776@google.com>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120717204126.GE24336@google.com>
 <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
 <20120718221044.GJ24336@google.com>
 <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
 <20120720175959.GA32741@cathedrallabs.org>
 <alpine.LSU.2.00.1207221136160.1896@eggly.anvils>
 <20120723181252.GW14236@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120723181252.GW14236@cathedrallabs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 23, 2012 at 02:12:52PM -0400, Aristeu Rozanski wrote:
> > Will "lsattr -R" in the cgroupfs mountpoint do enough to judge how
> > much memory is being used in this way?  I expect not, but I'm
> > unfamliar with it: you may need to show counts elsewhere.
> 
> that's for ext{2,3,4} file attributes, not extended attributes. but agreed,
> there's a need to have this stat somewhere. Tejun, any ideas?

No idea.  Don't we need some mechanism to limit the amount of memory
consumed too?  Also, do you know what type of metadata systemd is
trying to store in cgroupfs?  Depending on the size requirement, it
might not be worth it to implement it using kernel memory.

Thanks.

-- 
tejun
