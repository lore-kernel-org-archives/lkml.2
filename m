Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0L2O6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:58:16 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44290 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0L2O6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:58:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6210"; a="68640658"
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Daniel Walker <dwalker@codeaurora.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>
In-Reply-To: <AANLkTikGe3D-ujM9jqcOtk1cGmtLtUiV3kMkam1N8fyM@mail.gmail.com>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	 <201012272215.52642.arnd@arndb.de> <1293551490.24601.10.camel@m0nster>
	 <201012291247.27663.arnd@arndb.de>
	 <AANLkTikGe3D-ujM9jqcOtk1cGmtLtUiV3kMkam1N8fyM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 06:58:07 -0800
Message-ID: <1293634687.4128.10.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 22:42 +0800, Hillf Danton wrote:
> On Wed, Dec 29, 2010 at 7:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 28 December 2010 16:51:30 Daniel Walker wrote:
> >> We for sure don't want new semaphores, or new semaphore usage in the
> >> kernel ..
> 
> Would you please, Daniel, explain why there are so my file systems under
> the fs directory? Would you think the ext file system is better than others?
> 
> And why there are in kernel spin lock, read/write lock, mutex, rw_mutex,
> rtmutx, and semaphore, timer and hrtimer?
> 
> Could timer be removed tonight?

The problem with semaphores is that people use them in ways that are not
very nice, and not very efficient.. Since they are so flexible they can
be used in all sorts of ways, many of which are not clean. This is why,
if you read the kernel history, most semaphore have been removed from
the kernel and replaced with much nicer and cleaner mutexes.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


