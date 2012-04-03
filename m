Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2DCSwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:52:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51195 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2DCSwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:52:20 -0400
Date: Tue, 3 Apr 2012 11:52:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Message-ID: <20120403185216.GD27794@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
 <20120330222936.GI28934@google.com>
 <4F7A6D13.4060704@parallels.com>
 <20120403184719.GB27794@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403184719.GB27794@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 11:47:19AM -0700, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Tue, Apr 03, 2012 at 07:22:59AM +0400, Glauber Costa wrote:
> > Do I need to send you a patch to remove memcg's populate on top of this ?
> 
> populate is already gone.  My memory is a bit fuzzy now.  Can you spot
> something broken / to be improved re. memcg cftypes in the current
> cgroup/for-3.5 branch?

Ugh... brainfart.  Please disregard the previous message.  Can you
please resend the patches on top of cgroup/for-3.5 and use Li's new
address - lizefan@huawei.com ?

Thanks.

-- 
tejun
