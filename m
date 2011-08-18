Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1HRAbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 20:31:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28964 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1HRAbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 20:31:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6441"; a="111107442"
Date: Wed, 17 Aug 2011 19:31:08 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 00/36] Hexagon: Add support for Qualcomm Hexagon
 architecture
Message-ID: <20110818003108.GA4049@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org>
 <5653962.eQPS9muPhD@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5653962.eQPS9muPhD@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's good to finally see the source for this, and I have a good feeling
> about the quality of the code, so it should not be a problem to resolve
> the remaining issues in time to get it into the next merge window.
> 
> I have gone over all patches once now and commented about everything
> that looked odd or wrong. Most of the issues are really just small
> changes. Removing support for the legacy syscalls is an easy change
> in the kernel but it might require significant changes in the libc
> implementation. It's not a big problem if your libc still requires the
> old interfaces at the time the architecture gets merged upstream,
> that will just mean that you have to have a small kernel patch to add
> them back in while transitioning to the new libc.

Thanks for reviewing the patches!  I've started working on some of the
feedback and will be answering other questions as I get to them.

> As I commented on patch 33, I think the platform specific patches should
> not get merged before everything is converted to device tree based
> probing. This should also not keep the rest from going in. I think it
> would be good to do the conversion together with the ARM-MSM platform
> that seems to share a lot of the device specific code, and it would
> be bad to end up with duplicate work here or (worse) with incompatible
> DT bindings.

OK, sounds fair.  I have been working on devtree code on the side, but for
this first submission, it sounds like I'll just gut the platform code
out.


Thanks,
Richard Kuo


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
