Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2ATRef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:34:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56922 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab2ATRed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:34:33 -0500
Date: Fri, 20 Jan 2012 09:34:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: x86, mce, Use user return notifier in mce
Message-ID: <20120120173427.GC3336@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
 <CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com>
 <1326436352.8294.22.camel@yhuang-dev>
 <CA+8MBb+oqJZDYvmh8E6RB2MRp5fDj298Qjc4zs-rmyGkA4F3cw@mail.gmail.com>
 <1326676875.8294.30.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326676875.8294.30.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 16, 2012 at 09:21:15AM +0800, Huang Ying wrote:
> "high priority work queue" sounds like a good idea.
> 
> Hi, Tejun,
> 
> Do you think the concept of "high priority work queue" is possible?
> This is the requirement from our RAS guys.  To make some hardware
> recovery function to be executed ASAP in process context.

Take a look at Documentation/workqueue.txt.  It already has
WQ_HIGHPRI.

Thanks.

-- 
tejun
