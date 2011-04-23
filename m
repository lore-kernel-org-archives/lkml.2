Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1DWAEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:04:42 -0400
Received: from kroah.org ([198.145.64.141]:45311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750Ab1DWAEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:04:39 -0400
Date: Fri, 22 Apr 2011 17:00:57 -0700
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com, Victor Goldenshtein <victorg@ti.com>
Cc: linux-kernel@vger.kernel.org, pavan_savoy@sify.com
Subject: Re: [PATCH 3/3] drivers:misc:ti-st: fix skip remote baud logic
Message-ID: <20110423000057.GA28399@kroah.com>
References: <1302256664-23688-1-git-send-email-pavan_savoy@ti.com>
 <1302256664-23688-2-git-send-email-pavan_savoy@ti.com>
 <1302256664-23688-3-git-send-email-pavan_savoy@ti.com>
 <1302256664-23688-4-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302256664-23688-4-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 04:57:44AM -0500, pavan_savoy@ti.com wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> Texas Instruments WiLink connectivity combo chipsets support custom baud
> rates over its UART interface.
> This can be achieved by sending the change remote baud rate command.
> Since the baud rate can be properly set by the user-space on shared
> transport the remote chip-side and local host-side baud rate is change
> by the User Space Init Manager.
> 
> This patch when encounters the same command inside the firmware,
> attempts to skip such command since it is handled by the user-space.
> The logic to skip the command when it is un-commented is fixed by this
> patch.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> Author:    Victor Goldenshtein <victorg@ti.com>

Um, we need a signed-off-by from the original author here.  Victor, can
you please send me that?

thanks,

greg k-h
