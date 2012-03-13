Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab2CMQH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:07:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41043 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2CMQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:07:25 -0400
Date: Tue, 13 Mar 2012 09:02:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Michal Schmidt <mschmidt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120313160218.GC7349@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <20120313134922.GB29169@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313134922.GB29169@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 13, 2012 at 09:49:22AM -0400, Vivek Goyal wrote:
> So everything will be under single hierarchy? How will we control that
> what controllers are active on what cgroups? Or all controllers are going
> to be active on all cgroups on that hierarchy. 
> 
> That would be bad for IO cgroups where a better way to use it to isolate
> the trouble making workload and run rest in root or a common cgroup.

Depending on active configs, I guess, or maybe we'll have active
controllers mask which can also be used for single-level restriction
for controllers which don't support full hierarchy.

Thanks.

-- 
tejun
