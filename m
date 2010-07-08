Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab0GHUQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:16:25 -0400
Received: from kroah.org ([198.145.64.141]:58241 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab0GHUQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:16:24 -0400
Date: Thu, 8 Jul 2010 13:07:10 -0700
From: Greg KH <greg@kroah.com>
To: James K Pruitt <pruittjk@cableone.net>
Cc: gregkh@suse.de, mauricedawson2699@googlemail.com, stewart_r@aliencamel.com,
       mithlesh@linsyssoft.com, u.kleine-koenig@pengutronix.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: fixed KERN_ facility level warning
Message-ID: <20100708200710.GA30172@kroah.com>
References: <1278259791-29441-1-git-send-email-pruittjk@cableone.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278259791-29441-1-git-send-email-pruittjk@cableone.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 11:09:51AM -0500, James K Pruitt wrote:
> This is a patch to the ni_labpc.c file that fixes a "KERN_" facility level
> warning on line 529 found by the checkpatch.pl utility.
> 
> Signed-off-by: James K Pruitt <pruittjk@cableone.net>

This doesn't apply to the linux-next tree, care to respin it?

thanks,

greg k-h
