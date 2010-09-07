Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0IHAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:25:27 -0400
Received: from kroah.org ([198.145.64.141]:51489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab0IHAZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:25:24 -0400
Date: Tue, 7 Sep 2010 16:57:04 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, kconfig and hal fixes
Message-ID: <20100907235704.GC12823@kroah.com>
References: <5BFACB1451C1459BA8562A5561D0A4E6@stanford.edu> <1283386101.17399.10.camel@odc-laptop> <1283467434.4378.11.camel@odc-laptop> <1283887330.7250.6.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283887330.7250.6.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 12:22:10PM -0700, David Cross wrote:

First off, what's with the "Re:" of the Subject?  What are you
responding to here?

> This patch contains the kconfig changes necessary to fix build errors
> that could come up in the linux-next version. It also includes an
> additional HAL layer for the west bridge CRAM interface.

Again, one patch per change, please break this up.

> The inclusion
> of this interface support did require the reorganization of some of the
> existing code, which is part of the reason for the size of the patch.
> Moving files and directories makes this patch seem larger than it really
> is.

If you use git you can send a patch that properly shows only what
changes even if the file is moved.  Care to do that?

> The Kconfig changes are closely related to the inclusion of the CRAM
> HAL layer, and as such this patch is difficult to logically separate. 

Why is it necessary?

> The linux-next tree does not seem to have a config for the zoom2, and
> trying to build it for that board seems to make the compilation break.

Why should the driver care about which arch it is built for?  It should
build on _all_ arches, right?

> As such, the only thing that I tested was compilation using the two
> different HALs (one of which is added in this patch). Please let me know
> if there are problems or questions with this.

Why do you need a "HAL" at all here?

confused,

greg k-h
