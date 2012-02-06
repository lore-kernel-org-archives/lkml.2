Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2BFREK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:04:10 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59060 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755597Ab2BFREH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:04:07 -0500
X-Sasl-enc: olIliIN5ubIgB6/9JoTo48adMR4xi9O6E4iBCcLZ6xtl 1328547846
Date: Mon, 6 Feb 2012 09:03:49 -0800
From: Greg KH <greg@kroah.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        rob.lee@linaro.org
Subject: Re: [linux-pm] [RFC PATCH] thermal: Add support to report cooling
 statistics achieved by cooling devices
Message-ID: <20120206170348.GA19749@kroah.com>
References: <1326878467-17766-1-git-send-email-amit.kachhap@linaro.org>
 <20120206165658.GA28687@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206165658.GA28687@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 05:56:58PM +0100, Pavel Machek wrote:
> Hi!
> 
> > Add a sysfs node code to report effective cooling of all cooling devices
> > attached to each trip points of a thermal zone. The cooling data reported
> > will be absolute if the higher temperature trip points are arranged first
> > otherwise the cooling stats is the cumulative effect of the earlier
> > invoked cooling handlers.
> > 
> > The basic assumption is that cooling devices will bring down the temperature
> > in a symmetric manner and those statistics can be stored back and used for
> > further tuning of the system.
> 
> /sys fs should be one-value-per-file, talk to gregkh.

That's correct.

Why not use debugfs for this instead?

thanks,

greg k-h
