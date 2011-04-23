Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab1DWAGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:06:40 -0400
Received: from kroah.org ([198.145.64.141]:45327 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab1DWAGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:06:36 -0400
Date: Fri, 22 Apr 2011 17:06:12 -0700
From: Greg KH <greg@kroah.com>
To: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/base/core.c: Fixed brace coding style issue.
Message-ID: <20110423000612.GB8419@kroah.com>
References: <1303161412.6672.3.camel@ks-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303161412.6672.3.camel@ks-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 04:16:52PM -0500, Karthigan Srinivasan wrote:
> >From 62183d5695ad36b6cef0fbd7617f0060f2dd391d Mon Sep 17 00:00:00 2001
> From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
> Date: Mon, 18 Apr 2011 16:05:05 -0500
> Subject: [PATCH] drivers/base/core.c: Fixed brace coding style issue.

Why is this in the body of the patch?  Please don't do that, it forces
me to edit it by hand.  Which is a pain when you have to do it for 900+
patches per release...

So next time, please do this.

thanks,

greg k-h
