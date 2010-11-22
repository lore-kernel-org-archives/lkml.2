Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0KVSqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:46:43 -0500
Received: from kroah.org ([198.145.64.141]:36070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab0KVSqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:46:42 -0500
Date: Mon, 22 Nov 2010 10:45:59 -0800
From: Greg KH <greg@kroah.com>
To: Len Brown <lenb@kernel.org>
Cc: stable@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [linux-pm] [git pull 2.6.36.stable] intel_idle
 patches for 2.6.36.stable
Message-ID: <20101122184559.GA10879@kroah.com>
References: <alpine.LFD.2.00.1011151227190.2939@x980>
 <alpine.LFD.2.00.1011170322270.24426@x980>
 <alpine.LFD.2.00.1011170331150.24426@x980>
 <alpine.LFD.2.00.1011221318230.19247@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011221318230.19247@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 01:36:31PM -0500, Len Brown wrote:
> Hi Greg,
> 
> I retract my intel_idle pull requests for .stable
> 
> The idle-release branches in...
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/
> 	linux-idle-2.6.32.git
> 	linux-idle-2.6.35.git
> 	linux-idle-2.6.36.git
> 
> are for distros and others that want to run the latest intel_idle
> driver on the specified release.  The backports in these trees
> contain every upstream patch that touch the driver, including new
> platform support and any dependent cosmetic patches.
> 
> So they are optimized for the maintenance task of comparing
> the backport versus the upstream driver to verify the release
> includes everything that is upstream.
> However, as it does not exclude cosmetic or trivial patches,
> the backports do not qualify for inclusion in .stable.
> 
> Sorry to bother you.

No problem at all, glad to see you change your mind :)

thanks,

greg k-h
