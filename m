Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab0KVSgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:36:51 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:44059 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab0KVSgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:36:49 -0500
Date: Mon, 22 Nov 2010 13:36:31 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: stable@kernel.org
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [git pull 2.6.36.stable] intel_idle patches for
 2.6.36.stable
In-reply-to: <alpine.LFD.2.00.1011170331150.24426@x980>
Message-id: <alpine.LFD.2.00.1011221318230.19247@x980>
References: <alpine.LFD.2.00.1011151227190.2939@x980>
 <alpine.LFD.2.00.1011170322270.24426@x980>
 <alpine.LFD.2.00.1011170331150.24426@x980>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I retract my intel_idle pull requests for .stable

The idle-release branches in...
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/
	linux-idle-2.6.32.git
	linux-idle-2.6.35.git
	linux-idle-2.6.36.git

are for distros and others that want to run the latest intel_idle
driver on the specified release.  The backports in these trees
contain every upstream patch that touch the driver, including new
platform support and any dependent cosmetic patches.

So they are optimized for the maintenance task of comparing
the backport versus the upstream driver to verify the release
includes everything that is upstream.
However, as it does not exclude cosmetic or trivial patches,
the backports do not qualify for inclusion in .stable.

Sorry to bother you.

thanks,
Len Brown, Intel Open Source Technology Center
