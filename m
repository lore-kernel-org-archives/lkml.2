Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0EFXyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:54:52 -0400
Received: from kroah.org ([198.145.64.141]:38406 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0EFXyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:54:50 -0400
Date: Thu, 6 May 2010 16:54:33 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] drivers: staging: dream: fix smd in makefile
Message-ID: <20100506235433.GA4477@kroah.com>
References: <1273189739-1710-1-git-send-email-dwalker@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273189739-1710-1-git-send-email-dwalker@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 04:48:59PM -0700, Daniel Walker wrote:
> Not sure about this one.. Cause if you apply this then some SMD files
> don't compile anymore. There's some missing config options related to
> AMSS.
> 
> NOT-Signed-off-by: Daniel Walker <dwalker@codeaurora.org>

Heh, I'm not going to apply this then :)

> CC: Greg KH <greg@kroah.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/staging/dream/Makefile |    3 ++-

With the recent progression of your arch tree, and the
wakelock/suspend-blocker stuff, what's the need for these files to still
be in the staging directory at all?  Can't it be deleted and it go
through your tree?

thanks,

greg k-h
