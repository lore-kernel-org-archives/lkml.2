Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2ITNGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:06:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48130 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2ITNF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:05:59 -0400
Date: Thu, 20 Sep 2012 08:05:51 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, lwn@lwn.net,
        "criu@openvz.org" <criu@openvz.org>,
        Containers <containers@lists.linux-foundation.org>, users@openvz.org,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.2
Message-ID: <20120920130551.GB4605@sergelap>
References: <500D09C9.7060903@parallels.com>
 <505AECF0.6070607@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505AECF0.6070607@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Congratulations, Pavel and criu team, that's awesome!

Quoting Pavel Emelyanov (xemul@parallels.com):
> Hi!
> 
> I'm happy to announce that the next big step is done by the CRIU project.
> 
> The major achievement so far -- the tool can now dump and restore a simple LXC
> container. Another notable feature is the initial support for PTYs which is enough
> to play with c/r of a container with active ssh sessions from outside, or with
> a screen app with some simple stuff running inside.
> 
> A HOWTO describing an LXC container dump and restore is at http://criu.org/LXC
> 
> 
> The v0.2 can be downloaded from
> 
> 	http://download.openvz.org/criu/crtools-0.2.tar.bz2
> 
> 
> Other project resources are
> 
>   documentation and news:             http://criu.org
>   mainling list:                      https://openvz.org/mailman/listinfo/criu
>   git repo:                           http://git.criu.org/?p=crtools.git
>   kernel with not-yet-merged patches: https://github.com/cyrillos/linux-2.6.git
> 
> Thanks,
> Pavel
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
