Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935244Ab1KJPsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:48:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59289 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab1KJPsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:48:19 -0500
Date: Thu, 10 Nov 2011 07:48:12 -0800
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the pm tree
Message-ID: <20111110154812.GG27258@google.com>
References: <20111110133106.12e519d17f6a28adfee3b883@canb.auug.org.au>
 <201111101311.32012.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111101311.32012.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 01:11:31PM +0100, Rafael J. Wysocki wrote:
> On Thursday, November 10, 2011, Stephen Rothwell wrote:
> > Hi Rafael,
> > 
> > After merging the pm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > mm/oom_kill.c: In function 'select_bad_process':
> > mm/oom_kill.c:326:5: error: implicit declaration of function 'thaw_process'
> > 
> > Caused by commit 944e192db53c ("freezer: rename thaw_process() to
> > __thaw_task() and simplify the implementation").
> > 
> > I have used the pm tree from next-20111109 for today.
> 
> Thanks, I'll drop pm-freezer from my linux-next branch until that issue is
> fixed.

Will try to resolve soon.

Thanks.

-- 
tejun
