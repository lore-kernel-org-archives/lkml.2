Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2CTQD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:03:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52843 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2CTQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:03:55 -0400
Date: Tue, 20 Mar 2012 09:03:47 -0700
From: Tejun Heo <tj@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com
Subject: Re: [PATCH 03/10] cgroup: implement cgroup_add_cftypes() and
 friends
Message-ID: <20120320160347.GE5684@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <1331940963-15756-4-git-send-email-tj@kernel.org>
 <877gyfu025.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gyfu025.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Aneesh.

On Tue, Mar 20, 2012 at 02:22:02PM +0530, Aneesh Kumar K.V wrote:
> Instead of using CGROUP_SUBSYS_CFTYPES_COND, are you ok if other
> subsystem called cgroup_add_cftypes ?. I am looking at how this will
> impact http://article.gmane.org/gmane.linux.kernel.mm/75470 . With
> HugeTLB we cannot do the above. 

Yeah, sure.  Allowing dyanmic additions and removals of cftypes is the
whole point of the patchset.

Thanks.

-- 
tejun
