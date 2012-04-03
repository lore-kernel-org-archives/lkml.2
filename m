Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab2DCSrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:47:25 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44663 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2DCSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:47:23 -0400
Date: Tue, 3 Apr 2012 11:47:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Message-ID: <20120403184719.GB27794@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
 <20120330222936.GI28934@google.com>
 <4F7A6D13.4060704@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7A6D13.4060704@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Tue, Apr 03, 2012 at 07:22:59AM +0400, Glauber Costa wrote:
> Do I need to send you a patch to remove memcg's populate on top of this ?

populate is already gone.  My memory is a bit fuzzy now.  Can you spot
something broken / to be improved re. memcg cftypes in the current
cgroup/for-3.5 branch?

Thanks.

-- 
tejun
