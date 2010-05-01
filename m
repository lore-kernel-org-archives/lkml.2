Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab0EBENB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 00:13:01 -0400
Received: from kroah.org ([198.145.64.141]:37589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0EBEM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 00:12:59 -0400
Date: Sat, 1 May 2010 10:43:06 -0700
From: Greg KH <greg@kroah.com>
To: Dustin Dorroh <dustindorroh@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: ssc_dnp: adjusted comments: coding
	style issue
Message-ID: <20100501174306.GA22145@kroah.com>
References: <1272687720-27039-1-git-send-email-dustindorroh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272687720-27039-1-git-send-email-dustindorroh@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 09:22:00PM -0700, Dustin Dorroh wrote:
> Fixed a coding style issue.
> 
> Signed-off-by: Dustin Dorroh <dustindorroh@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ssv_dnp.c |   97 ++++++++++++++++--------------

This patch is already in the linux-next tree.  Can you please use that
tree to work off of?

thanks,

greg k-h
