Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab0KPUPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:15:35 -0500
Received: from kroah.org ([198.145.64.141]:57063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759442Ab0KPUPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:15:33 -0500
Date: Tue, 16 Nov 2010 12:08:41 -0800
From: Greg KH <greg@kroah.com>
To: Audun Hoem <audun.hoem@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: bcm: Arp.c: Checkpatch.pl fix
Message-ID: <20101116200841.GD12492@kroah.com>
References: <1289870088-18871-1-git-send-email-audun.hoem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289870088-18871-1-git-send-email-audun.hoem@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:14:48AM +0100, Audun Hoem wrote:
> Cleaned up the coding style. 80 line length limit warnings are in a comment.
> 
> Signed-off-by: Audun Hoem <audun.hoem@gmail.com>
> ---
>  drivers/staging/bcm/Arp.c |   63 ++++++++++++++++++++------------------------

This file is no longer in the linux-next tree so I can't apply this
patch :)

Care to resync and send patches only on the linux-next tree?

thanks,

greg k-h

