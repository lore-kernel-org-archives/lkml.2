Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab1DEHgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:36:00 -0400
Received: from kroah.org ([198.145.64.141]:59551 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1DEHf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:35:58 -0400
Date: Mon, 4 Apr 2011 21:59:04 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 00/22] Staging: hv: Cleanup-storage-drivers-phase-III
Message-ID: <20110405045904.GA4635@kroah.com>
References: <1301331615-26226-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301331615-26226-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:00:15AM -0700, K. Y. Srinivasan wrote:
> This patch-set deals with some of the style isues in blkvsc_drv.c. We also
> get rid most of the "dead code" in this file:
> 
> 	1) Get rid of most of the forward declarations in this file.
> 	   The only remaining forward declarations are to deal with 
> 	   circular dependencies.
> 
> 	2) Get rid of most of the dead code in the file. Some of
> 	   the functions in this file are place holders - they are not
> 	   fuly implementedi yet (blkvsc_ioctl(), blkvsc_media_changed(). 
> 	   We have retained some comments/dead code, to help us in the
> 	   final implementation.

For some reason, this patch series fails to apply after the first one.
So I've not applied any of them, care to resync and resend?

thanks,

greg k-h
