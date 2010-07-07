Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0GGCnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 22:43:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907Ab0GGCnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 22:43:11 -0400
Date: Tue, 6 Jul 2010 19:42:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Schottelius <nico-linux-2010-07-01@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       dri-devel@lists.freedesktop.org, netdev@vger.kernel.org
Subject: Re: Report for 2.6.35-rc3-00262-g984bc96
Message-Id: <20100706194222.fcf16e13.akpm@linux-foundation.org>
In-Reply-To: <20100701074052.GA3501@schottelius.org>
References: <20100701074052.GA3501@schottelius.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 09:40:52 +0200 Nico Schottelius <nico-linux-2010-07-01@schottelius.org> wrote:

> Good morning!
> 
> A short report on what's broken in 2.6.35-rc3-00262-g984bc96 with
> the Lenovo X201:

So you see two post-2.6.34 regressions?

> == xrandr ==
> 
> After using xrandr several times in xorg, the screen gets
> "fancy": blue/white/black changing patterns.
> Getting even more weired when changing to a conosle.
> 
> The only thing that keeps on working is the mouse cursor
> in xorg. This did not happen with 2.6.34-rcsomething, neither
> with 2.6.33 iirc.
> 
> This is a Intel Corporation Core Processor Integrated Graphics Controller (rev 02),
> attached xorg.log.

(cc dri-devel)

> == netlink/carrier messag ==
> 
> dhcpcd does not get updated when the link is established,
> need to restart it. 

(cc netdev)

> == suspend/resume (to ram) ==
> 
> So far no real crash! Only xorg is sometimes not coming up
> again, but this may be related to the first issue.
> 
> == wifi / intel 6000 ==
> 
> Works! Works! (Besides the netlink issue, which is annoying,
> but for all devices).

