Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab0HEDrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:47:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57631 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758684Ab0HEDrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:47:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX188+iU1Q9c8bu5ylbTuSN+KTfvnmb3Psrb+tUtRzz
	AfHdfaxbxdrhsq
Subject: Re: excessive wakeups in 2.6.35
From: Mike Galbraith <efault@gmx.de>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
In-Reply-To: <20100804203811.GA6479@redhat.com>
References: <20100804203811.GA6479@redhat.com>
Content-Type: text/plain
Date: Thu, 05 Aug 2010 05:48:11 +0200
Message-Id: <1280980091.7508.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 16:38 -0400, Dave Jones wrote:
> My laptop felt like it was about to burst into flames after I ran
> 2.6.35 on it for a while.  It actually got too hot to place on my legs.

Nomex + bigger battery :)

> Powertop showed it running over a 1000 wakeups a second while completely idle.
> 
> Chuck Ebbert pointed me at this diff..
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=396e894d289d69bacf5acd983c97cd6e21a14c08
> 
> which brings it back down to a much more respectable 80 wakeups a second.
> 
> Is this lined up for 2.6.35.1 ?

Yeah, it's tagged.  More trouble than it's worth, optimization dies.

	-Mike

