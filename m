Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2GTSFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:05:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45894 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2GTSFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:05:04 -0400
Date: Fri, 20 Jul 2012 11:04:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@ruivo.org>
Cc: Hugh Dickins <hughd@google.com>, Aristeu Rozanski <aris@redhat.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
Message-ID: <20120720180459.GJ32763@google.com>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120717204126.GE24336@google.com>
 <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
 <20120718221044.GJ24336@google.com>
 <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
 <20120720175959.GA32741@cathedrallabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720175959.GA32741@cathedrallabs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hugh, Aristeu.

On Fri, Jul 20, 2012 at 01:59:59PM -0400, Aristeu Rozanski wrote:
> hm, not sure that's what Tejun meant. tmpfs uses anonymous memory for the file
> contents, so reuse that infrastructure to allocate space for the extended
> attributes the same way, instead of using kmem.
> 
> First thing I can think of is to use whole pages for it to prevent further
> complexity. Shouldn't make much difference considering the usecases we have
> now (systemd and containers), right?

Yeah, that's what I meant.  The internal fragmentation is ugly but I
think that should do for now at least.

Thanks.

-- 
tejun
