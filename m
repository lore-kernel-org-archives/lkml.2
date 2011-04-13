Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1DMU4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:56:51 -0400
Received: from kroah.org ([198.145.64.141]:37734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862Ab1DMU4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:56:46 -0400
Date: Wed, 13 Apr 2011 13:34:23 -0700
From: Greg KH <greg@kroah.com>
To: Joost Pjotr Vermeer <jp@df5ea.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: backlight control broken on Sony VGN-P21Z with staging/gma500
Message-ID: <20110413203423.GA6152@kroah.com>
References: <BANLkTikq34nGQU=1U4uvrSu_mRPf-UjLRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikq34nGQU=1U4uvrSu_mRPf-UjLRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 09:54:45PM +0200, Joost Pjotr Vermeer wrote:
> Hi,
> 
> I tried the new gma500 driver from staging on my Sony VGN-P21Z. It
> seems to work very nice.
> 
> But backlight control does not work. It has worked with a previous
> version of the staging/gma500 driver. I can solve it by removing the
> call to acpi_video_register() from psb_driver_load() in psb_drv.c.
> 
> Can I try anything to find a more specific cause for this?

Use 'git bisect' to find the offending patch?

thanks,

greg k-h
