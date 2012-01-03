Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2ACVD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 16:03:56 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41527 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318Ab2ACVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 16:03:49 -0500
X-Sasl-enc: aNkPa0c4lsKEuTKGsC6P9F0WfnJR0cLTRKQIBOVWQAo4 1325624628
Date: Tue, 3 Jan 2012 13:01:44 -0800
From: Greg KH <greg@kroah.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Chris Wright <chrisw@sous-sol.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Sanjeev Premi <premi@ti.com>,
        Kyle Manna <kyle@kylemanna.com>, stable@vger.kernel.org
Subject: Re: Several MFD patches for stable
Message-ID: <20120103210144.GE17131@kroah.com>
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

Ok, I've applied these 3 to the 3.0-stable tree now.

> 3d6271f92e98094584fd1e609a9969cd33e61122 (mfd: Turn on the twl4030-madc MADC clock)

And this one to both 3.0-stable and 3.1-stable.

greg k-h
