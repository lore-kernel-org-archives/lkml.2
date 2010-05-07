Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab0EGQNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:13:21 -0400
Received: from kroah.org ([198.145.64.141]:49651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab0EGQNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:13:20 -0400
Date: Fri, 7 May 2010 09:13:14 -0700
From: Greg KH <greg@kroah.com>
To: David Dajun Chen <Dajun.Chen@diasemi.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
       sameo@linux.intel.com, lm-sensors@lm-sensors.org, rpurdie@rpsys.net,
       lrg@slimlogic.co.uk, dmitry.torokhov@gmail.com
Subject: Re: [PATCH] Device driver for DA9052 PMIC IC
Message-ID: <20100507161314.GA20909@kroah.com>
References: <3495EC08FA53E94AAA00CC4743D5BA7E010C1E94@pandora.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E010C1E94@pandora.diasemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 12:43:27PM +0100, David Dajun Chen wrote:
> Dear all,
> 
> It is device driver for DA9052 Power Management IC from Dialog Semiconductor.

What are we supposed to do with this?

Please read Documentation/SubmittingPatches for how to submit a patch
(hint, you need to break it up, and provide a "Signed-off-by:" line, and
send it to the correct people and subsystem mailing lists.)

And why did you add a selinux file?  I think something is wrong with how
you generated your patch.

thanks,

greg k-h
