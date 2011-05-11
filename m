Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab1EKXEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 19:04:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:36358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab1EKXEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 19:04:45 -0400
Date: Wed, 11 May 2011 15:55:40 -0700
From: Greg KH <gregkh@suse.de>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mark Brown <broonie@sirena.org.uk>,
        Jiejing Zhang <kzjeef@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Colin Cross <ccross@google.com>, Nishanth Menon <nm@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 3/3] PM / DEVFREQ: add sysfs interface (including user
 tickling)
Message-ID: <20110511225540.GA3492@suse.de>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
 <1305100723-29161-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305100723-29161-3-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 04:58:43PM +0900, MyungJoo Ham wrote:
> 1. System-wide sysfs interface
> - tickle_all	R: number of tickle_all execution
> 		W: tickle all devfreq devices
> - min_interval	R: devfreq monitoring base interval in ms
> - monitoring	R: shows whether devfreq monitoring is active or
>   not.
> 
> 2. Device specific sysfs interface
> - tickle	R: number of tickle execution for the device
> 		W: tickle the device

Any sysfs file change/addition/removal needs to have a
Documentation/ABI/ entry as well.  Please add that to this patch instead
of burying it in the changelog entry, where no one will be able to find
it in the future.

thanks,

greg k-h
