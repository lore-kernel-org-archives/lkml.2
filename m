Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab0D0WaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:30:11 -0400
Received: from kroah.org ([198.145.64.141]:55906 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab0D0WaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:30:04 -0400
Date: Tue, 27 Apr 2010 15:11:35 -0700
From: Greg KH <greg@kroah.com>
To: supermine290 <supermine290@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       Shawn Bohrer <shawn.bohrer@gmail.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Patch to comedi_fops.c
Message-ID: <20100427221135.GA8619@kroah.com>
References: <4BA8F51E.4090302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA8F51E.4090302@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 01:06:38PM -0400, supermine290 wrote:
> >From eb3bff4e8052a4075d82f1687e0338dc81d73256 Mon Sep 17 00:00:00 2001
> From: Jakob Penzien <jakob@bloodmoon.(none)>
> Date: Tue, 23 Mar 2010 12:52:14 -0400
> Subject: [PATCH] Staging: comedi: fix space before tab style issue in comedi_fops.c
>  This is a patch to the comedi_fops.c file that fixes up a tab style warning
>  found by the checkpathc.pl tool. This patch was done to 2.6.34 kernel.
>  Signed-off-by: Jakob Penzien <supermine290@gmail.com>

Sorry, but someone else already submited a patch for this before you :(

greg k-h
