Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1A0HaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:30:06 -0500
Received: from lo.gmane.org ([80.91.229.12]:48565 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab1A0HaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:30:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Date: Thu, 27 Jan 2011 07:26:12 +0000 (UTC)
Message-ID: <ihr6mk$qmm$4@dough.gmane.org>
References: <20110125235700.GR8008@google.com>
	<20110126144910.ce0646ec.akpm@linux-foundation.org>
	<20110126145703.a0f5add5.rdunlap@xenotime.net>
	<20110126151017.ed9e627c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 15:10:17 -0800, Andrew Morton wrote:

> On Wed, 26 Jan 2011 14:57:03 -0800
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
>> > I'm a bit surprised that this wasn't already tunable at boot-time
>> > and/or at runtime.
>> 
>> 
>> As WANG Cong replied:
>> 
>> Why? We already have "loglevel=" kernel parameter.
> 
> That's different.
> 
> Mandeep's patch addresses printks which didn't have a facility level.
> Longer-term, all these should be fixed, so they have an explicit
> facility level.  I suppose that short-term it would make sense to prefer
> to blurt these messages onto the console rather than hiding them. 
> Because they might be important.  And if they weren't important, they
> will then irritate enough people to get themselves fixed.

Yeah, agreed. Actually checkpatch.pl will complain if a patch
contains a printk without KERN_*, this somewhat stops us having
more printk's without KERN_*.

Thanks.

