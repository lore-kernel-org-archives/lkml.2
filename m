Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1IXVZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 17:25:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53791 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab1IXVZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 17:25:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/3] PM: Runtime PM and device PM QoS refinements
Date: Sat, 24 Sep 2011 23:23:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com, Ming Lei <tom.leiming@gmail.com>
References: <201108310017.03103.rjw@sisk.pl>
In-Reply-To: <201108310017.03103.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109242323.03474.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, August 31, 2011, Rafael J. Wysocki wrote:
> Hi,
> 
> This patchset illustrates how device PM QoS may be used along with
> PM domains in my view.
> 
> Actually, it consists of two parts.  Namely, patches [1-3/5] seem to be
> suitable for 3.2, unless somebody hates them, but patches [4-5/5] are
> total RFC.  They haven't been tested, only compiled, so the use of them
> is not encouraged (they may kill your dog or make your cat go wild, or
> do something equally nasty, so beware).  Their purpose is to illustrate
> an idea that I'd like to discuss at the PM miniconference during the
> LPC.
> 
> [1/5] - Split device PM domain data into a "base" and additional fields
>         (one need_restore field at the moment, but the subsequent patches
>         add more fields).
> 
> [2/5] - Make runtime PM always release power.lock if power.irq_safe is set.
> 
> [3/5] - Add function for reading device PM QoS values safely.
> 
> [4/5] - Add governor function for stopping devices.
> 
> [5/5] - Add generic PM domain power off governor function.

I have updated patches [1-3] after receiving some feedback and the result
follows.  These patches are regarded as 3.2 material, if no one has
objections.

[1/3] - Split device PM domain data into a "base" and additional fields
        (one need_restore field at the moment).
 
[2/3] - Make runtime PM always release power.lock if power.irq_safe is set.
 
[3/3] - Add function for reading device PM QoS values safely.

Thanks,
Rafael

