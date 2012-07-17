Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2GQV3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:29:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55649 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754695Ab2GQV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:29:07 -0400
X-Sasl-enc: lMpnCGLqFRFij98YicravsZGMvry/qhG9yPB5VsuP+96 1342560546
Date: Tue, 17 Jul 2012 14:29:05 -0700
From: Greg KH <greg@kroah.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] 3.4-stable: Fix for leapsecond caused hrtimer/futex
 issue
Message-ID: <20120717212905.GA9253@kroah.com>
References: <1342507196-54327-1-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342507196-54327-1-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 02:39:49AM -0400, John Stultz wrote:
> Here is backport of the leapsecond fixes to 3.4-stable. These are very
> straight forward, and backported to 3.4.x with no collisions or changes.
> 
> This patchset resolve the early hrtimer/futex expiration issue
> widely seen after the June 30th leapsecond.
> 
> I've booted and tested this patchset on two boxes and run through a number
> of leapsecond related stress tests. However, additional testing and review
> would be appreciated.

All now applied, thanks for doing this, that made my life so much
easier.

greg k-h
