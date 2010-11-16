Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab0KPP0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:26:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39094 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751011Ab0KPP0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:26:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18RLGwbFooRaHxsq1MdUNP/NVGhgYt9xXLUj3J21G
	9ezQkK220Jqx1d
Subject: Re: [performance bug] volanomark regression on 37-rc1
From: Mike Galbraith <efault@gmx.de>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: "Alex,Shi" <alex.shi@intel.com>, ncrao@google.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, linux-kernel@vger.kernel.org,
        "Chen, Tim C" <tim.c.chen@intel.com>, zheng.z.yan@intel.com
In-Reply-To: <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
References: <1289900042.27424.253.camel@debian>
	 <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 08:26:36 -0700
Message-ID: <1289921196.5169.176.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 20:38 +0600, Rakib Mullick wrote:

> Does VolanoMark is used for scheduler benchmarking? If I'm not wrong,
> I don't think it directly relates to scheduler benchmarking.

It's not generally considered to be a wonderful benchmark, but it is a
good indicator, and worth keeping an eye on IMHO.

I don't recall whether that patch works with the idle testcase without
resetting the throttle, or if it's only a bit less effective.  If it's
only a little less effective, I'd be inclined to just whack the reset as
Alex did.  Whatever is done has to prevent high frequency balancing.

	-Mike

