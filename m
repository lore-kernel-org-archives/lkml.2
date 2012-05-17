Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab2EQG70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 02:59:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:24166 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab2EQG7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 02:59:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144260778"
Date: Thu, 17 May 2012 14:59:22 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Boot error: x86/efi/ioremap kconfig:x86_64-nfsroot commit:a790068
Message-ID: <20120517065922.GA11817@localhost>
References: <20120517030652.GA8188@localhost>
 <1337236495.27692.27.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337236495.27692.27.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Thu, May 17, 2012 at 07:34:55AM +0100, Matt Fleming wrote:
> On Thu, 2012-05-17 at 11:06 +0800, wfg@linux.intel.com wrote:
> > Hi Matt,
> > 
> > FYI, starting from this commit, the kernel immediately reboots in my
> > kvm boot tests..
> 
> Hi Fengguang,
> 
> Yeah, this commit is broken. I pushed it to my repository so that I
> could test it on all of my machines, but quickly discovered that it
> contains some bugs.

OK, I got it.

> How come you are running are kernel built from that branch? I only
> created it yesterday. The majority of branches in my repository are work
> in progress, at least until they appear in a pull request on lkml. Which
> means they may contain blatantly broken commits.

I happen to be building a kernel test backend for our team and
hopefully for the wider kernel community.

What I do is to fetch a number of git trees (including yours) into my
test server, iterate through *all* remote branches and test out *every
single* commits there.

> But anyway, thanks for testing as it confirms that the commit is indeed
> buggy!

My pleasure :)

Thanks,
Fengguang
