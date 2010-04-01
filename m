Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab0DATnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:43:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab0DATnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:43:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 (was: Re: Linux 2.6.34-rc3)
Date: Thu, 1 Apr 2010 21:46:27 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>, dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Clemens Ladisch <clemens@ladisch.de>,
       Alex Deucher <alexdeucher@gamil.com>, stable@kernel.org,
       Greg KH <gregkh@suse.de>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <201004010313.32920.rjw@sisk.pl> <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012146.27223.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010, Linus Torvalds wrote:
> 
> On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:
> > 
> > OK, I've verified that partial revert (below) is sufficient.
> 
> Hmm. Through the DRM merge I just did, this area actually conflicted, and 
> the resolved version is now
> 
>         if ((rdev->family >= CHIP_RV380) &&
>             (!(rdev->flags & RADEON_IS_IGP))) {
> 
> which presumably also fixes your issue?

Yes, it does.

Rafael
