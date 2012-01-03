Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2ACQVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:21:21 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:58634 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947Ab2ACQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:21:18 -0500
X-Sasl-enc: qB1+ocTS5dqZqrTVHN65rmvsa4T4zyUNz4TQVrnE5D3T 1325607677
Date: Tue, 3 Jan 2012 08:16:56 -0800
From: Greg KH <greg@kroah.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Chris Wright <chrisw@sous-sol.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Sanjeev Premi <premi@ti.com>,
        Kyle Manna <kyle@kylemanna.com>, stable@vger.kernel.org
Subject: Re: Several MFD patches for stable
Message-ID: <20120103161656.GA25909@kroah.com>
References: <4F031233.7040007@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F031233.7040007@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 04:35:31PM +0200, Igor Grinberg wrote:
> Hi Greg, Chris,
> 
> I've found several MFD patches that I think should have been
> applied also to stable, but they hadn't been applied
> (probably because nobody cared to send them to stable@vger.kernel.org).
> 
> The patches are upstream:
> e178ccb33569da17dc897a08a3865441b813bdfb (mfd: Fix mismatch in twl4030 mutex lock-unlock)
> 66cc5b8e50af87b0bbd0f179d76d2826f4549c13 (mfd: Copy the device pointer to the twl4030-madc structure)
> d0e84caeb4cd535923884735906e5730329505b4 (mfd: Check for twl4030-madc NULL pointer)
> 3d6271f92e98094584fd1e609a9969cd33e61122 (mfd: Turn on the twl4030-madc MADC clock)
> 
> I don't know what is right flow that I should follow
> to get those into the stable tree.

Read Documentation/stable_kernel_rules.txt for how to do this (hint, you
did it properly, with a only few minor things missed.)

What kernel version(s) do you want these applied to?  What order should
they be applied in?

thanks,

greg k-h
