Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1DERUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:20:34 -0400
Received: from kroah.org ([198.145.64.141]:59177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1DERUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:20:33 -0400
Date: Tue, 5 Apr 2011 10:21:35 -0700
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        eugene.epshteyn@intel.com
Subject: Re: [PATCH 1/1] staging: sep: remove dependency on memrar driver
Message-ID: <20110405172135.GA20622@kroah.com>
References: <1302023393-28057-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302023393-28057-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 10:09:53AM -0700, Mark Allyn wrote:
> Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> ---
>  drivers/staging/sep/sep_driver.c |   59 +------------------------------------

Alan already sent me this patch, and it's in the staging-next tree,
right?  Or is this a new one that I need to do on top of the current
tree as I missed something?

thanks,

greg k-h
