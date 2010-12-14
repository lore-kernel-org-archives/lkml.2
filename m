Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab0LNWG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:06:26 -0500
Received: from waste.org ([173.11.57.241]:56534 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0LNWGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:06:25 -0500
Subject: Re: [PATCH v3 21/22] netoops: Add user-programmable boot_id
From: Matt Mackall <mpm@selenic.com>
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
In-Reply-To: <AANLkTi=Q+LaS7yaU_4ThkhMUM-q8S3JTuwMWqAikQPgH@mail.gmail.com>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
	 <20101214213048.17022.58746.stgit@mike.mtv.corp.google.com>
	 <1292362957.3446.851.camel@calx>
	 <AANLkTi=Q+LaS7yaU_4ThkhMUM-q8S3JTuwMWqAikQPgH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 16:06:18 -0600
Message-ID: <1292364378.3446.854.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 13:59 -0800, Mike Waychison wrote:
> On Tue, Dec 14, 2010 at 1:42 PM, Matt Mackall <mpm@selenic.com> wrote:
> > On Tue, 2010-12-14 at 13:30 -0800, Mike Waychison wrote:
> >> Add support for letting userland define a 32bit boot id.  This is useful
> >> for users to be able to correlate netoops reports to specific boot
> >> instances offline.
> >
> > This sounds a lot like the pre-existing /proc/sys/kernel/random/boot_id
> > that's used by kerneloops.org.
> 
> Could be.  I'm looking at it now... There is no documentation for this
> boot_id field?

Probably not. It's just a random number generated at boot.

> Reusing this guy would work, except that it doesn't appear to allow
> arbitrary values to be set.  We need to inject our boot sequence
> number (which is figured out in userland) in the packet somehow as we
> need to correlate it to our other monitoring systems.

What happens if you oops before userspace is available?

-- 
Mathematics is the supreme nostalgia of our time.


