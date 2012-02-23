Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab2BWWii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:38:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46887 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab2BWWig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:38:36 -0500
Date: Thu, 23 Feb 2012 14:38:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120223223832.GK22536@google.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222183351.GD32694@google.com>
 <20120223194109.GI19691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223194109.GI19691@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 23, 2012 at 02:41:10PM -0500, Vivek Goyal wrote:
> Considering everything internally as flat, isn't it simpler. So cgroup 
> tree still might look hierarchical but actually controller treats it
> as.
> 				root
> 		              / / | \ \
> 			    g1 g2 g3 g4 g5

I don't know.  Mixing the above with controllers which implement
proper nesting makes my head explode (why is there a hierarchy at
all?).  Root is always special anyway.  Just treating root differently
and collapsing the rest of hierarchies should do, right?

Thanks.

-- 
tejun
