Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab2CUOiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:38:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab2CUOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:38:47 -0400
Date: Wed, 21 Mar 2012 09:38:42 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Shea Levy <shea@shealevy.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] Add driver for Apple gmux device
Message-ID: <20120321143842.GB23643@thinkpad-t410>
Mail-Followup-To: Shea Levy <shea@shealevy.com>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org,
	Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
References: <1331926882-22979-1-git-send-email-seth.forshee@canonical.com>
 <4F69CB5F.70002@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F69CB5F.70002@shealevy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 08:36:47AM -0400, Shea Levy wrote:
> Hi Seth,
> 
> On 03/16/2012 03:41 PM, Seth Forshee wrote:
> >Apple laptops with hybrid graphics have a device named gmux that is used
> >for switching between GPUs and backlight control. On many models this is
> >the only reliable method for controlling the backlight.
> >
> >This series adds initial support for the gmux device, along with
> >anciallary support for disabling apple_bl when the gmux device is
> >detected. Initially only backlight control is supported.
> >
> >
> 
> I've done some basic testing on my MBP 5,3 (just setting a few
> brightness levels, nothing fancy), and it all works, so feel free to
> add my basic
> 
> Tested-by: Shea Levy <shea@shealevy.com>
> 
> if you wish. Please let me know if you need testing for future gmux
> features.

Thanks for testing! Matthew has already merged the patch to his tree
though, so I won't be able to add your tag.

> A few questions:
>     * I'm using nouveau, and with the gmux I have both
> gmux_backlight and nv_backlight (which never worked) in
> /sys/class/backlight, is this expected?

That's a better question for the nouveau developers. nouveau has some
criteria it uses to determine whether or not it should supply a
backlight device, and apparently that's all passing even though the
backlight control doesn't work.

>     * Is there anything I can do to test the backlight interface in
> addition to setting brightness levels?

The testing you've already done is sufficient.

>     * Besides the sysfs backlight interface, are there any other
> userspace-visible changes your driver makes that I should test?

Not at this time, no.

Thanks,
Seth

