Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1DSUVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:21:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:56792 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab1DSUVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:21:05 -0400
Date: Tue, 19 Apr 2011 13:19:50 -0700
From: Greg KH <gregkh@suse.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: Driver for Silicon Labs Si570 and compatibles
Message-ID: <20110419201950.GA9725@suse.de>
References: <1303245022-5765-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303245022-5765-1-git-send-email-guenter.roeck@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 01:30:22PM -0700, Guenter Roeck wrote:
> This driver adds support for Si570, Si571, Si598, and Si599
> programmable XO/VCXO.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  Documentation/misc-devices/si570 |   61 ++++++
>  MAINTAINERS                      |    7 +
>  drivers/misc/Kconfig             |   10 +
>  drivers/misc/Makefile            |    1 +
>  drivers/misc/si570.c             |  398 ++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/si570.h        |   23 +++

This file should be in include/linux/platform_data/, right?

And as you have created sysfs files, you need to also provide the proper
Documentation/ABI/ files. Please add them in your next resend of this
patch.

Also, please run your patch through scripts/checkpatch.pl before sending
it out, and fix the issues it finds, otherwise people will just repeat
them here, which is boring...

thanks,

greg k-h
