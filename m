Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0D1XIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:08:16 -0400
Received: from kroah.org ([198.145.64.141]:47806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab0D1XIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:08:15 -0400
Date: Wed, 28 Apr 2010 15:47:00 -0700
From: Greg KH <greg@kroah.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, pavel@ucw.cz, diegoliz@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mds.c whitspace, indentation etc.
Message-ID: <20100428224700.GA24604@kroah.com>
References: <1268670973-6223-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268670973-6223-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 05:36:13PM +0100, Lars Lindley wrote:
> I fixed most of the problems found by checkpatch.pl.
> Some long lines are left and some KERN_..
> This is a new revised patch against master with changes
> after comments from Stefan Richter and Dan Carpenter.
> Forget the old one.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/staging/winbond/mds.c |  652 ++++++++++++++++++++++-------------------

This doesn't apply due to other changes in this driver by someone else
:(

sorry,

greg k-h
