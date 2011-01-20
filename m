Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1ATTR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:17:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:51705 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753238Ab1ATTR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:17:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19zVFoJk3BzWKrcy8oCst0gA3u6vFsJ8nctH1dRX7
	ojtdBffXuuB+4Z
Subject: Re: [BUG] 2.6.38-rc1-git1: hard lockup related to i915 / automated
 cgroup scheduling
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, airlied@linux.ie,
        jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTi=GjnyE1_RosS_L_sn=QCTDSgO7v9EL+1bpJTu7@mail.gmail.com>
References: <4D387109.9020207@t-online.de>
	 <AANLkTi=GjnyE1_RosS_L_sn=QCTDSgO7v9EL+1bpJTu7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 20:17:53 +0100
Message-ID: <1295551073.8055.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 09:58 -0800, Linus Torvalds wrote:
> On Thu, Jan 20, 2011 at 9:29 AM, Knut Petersen
> <Knut_Petersen@t-online.de> wrote:
> > Kernel 2.6.38-rc1 and -git1 will lock my AOpen i915GMm-HFS
> > at the end of  KDE startup if automatic process group scheduling
> > is actived in kernel config. A hard reset is necessary.
> > Without automatic process group scheduling everything is ok.
> 
> Interesting. Most likely timing-related, but maybe there's some actual
> memory corruption. Adding the scheduler guys just in case.

I have a laptop with intel hw, will try it as soon as I can, but that
won't be tomorrow for sure, weekend at the earliest.

Knut: please send me your .config offline.

	-Mike

