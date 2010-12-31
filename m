Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0LaPxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 10:53:00 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:43474 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0LaPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 10:52:59 -0500
Date: Fri, 31 Dec 2010 10:52:48 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Paul Rolland <rol@witbe.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dave Airlie <airlied@redhat.com>, Keith Packard <keithp@keithp.com>
Subject: Re: [Bug #22542] [2.6.37-rc1] drm:i195 errors
In-Reply-To: <201012311647.24673.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1012311050530.3688@localhost6.localdomain6>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <sV7shrPOroO.A.3WH.nA8GNB@chimera> <20101231113021.1f086baa@tux.DEF.witbe.net> <201012311647.24673.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010, Rafael J. Wysocki wrote:

> On Friday, December 31, 2010, Paul Rolland wrote:
> > Hello,
> >
> > I'm now running 2.6.37-rc8, and I still have :
> > Dec 31 11:03:10 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> >
> > as well as :
> >
> > Dec 31 10:44:53 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
> > Dec 31 10:49:34 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
>
> There were some last-minute fixes related to i915 added to the
> Linus' tree after 2.6.37-rc8.  Perhaps you can give them a try?

  if this is in any way related to various systems booting to a black
screen (as i described earlier), i built an absolutely up-to-date
kernel from the latest tree and that didn't solve the problem.  i'm
open to testing suggestions.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
