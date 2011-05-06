Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1EFVYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:24:06 -0400
Received: from kroah.org ([198.145.64.141]:54594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747Ab1EFVYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:24:05 -0400
Date: Fri, 6 May 2011 14:22:07 -0700
From: Greg KH <greg@kroah.com>
To: "Javier M. Mellid" <jmunhoz@igalia.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: sm7xx: Use kernel framebuffer mode setting
Message-ID: <20110506212207.GA3222@kroah.com>
References: <1304702696-9403-1-git-send-email-jmunhoz@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304702696-9403-1-git-send-email-jmunhoz@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 07:24:56PM +0200, Javier M. Mellid wrote:
> This patch implements dynamic framebuffer mode setting.
> 
> Previous code works with mode setting in a hard code way. Previous hard
> code configuration is used as default configuration if dynamic mode
> setting or boot mode setting (via sm712vga_setup) is not used.
> 
> Tested with SM712 supporting 1024x600x16 as default hardware resolution.
> 
> Changes:
> 
> - Implement fb_check_var and fb_set_par callbacks
> - Remove __maybe_unused decorator in function being used (sm712vga_setup)
> - Minor cleanup on initialization structs related with mode settings
> - Updated author copyright
> - Updated TODO file
> 
> Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
> ---
>  drivers/staging/sm7xx/TODO     |    1 -

This applies with fuzz, this leads me to believe that you didn't test
this on the latest linux-next tree, right?

What did you make this patch against?

thanks,

greg k-h
