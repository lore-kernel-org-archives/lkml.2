Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab1DWFmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 01:42:13 -0400
Received: from kroah.org ([198.145.64.141]:43586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1DWFmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 01:42:08 -0400
Date: Fri, 22 Apr 2011 22:41:15 -0700
From: Greg KH <greg@kroah.com>
To: Pavan Savoy <pavan.savoy@gmail.com>
Cc: linux-kernel@vger.kernel.org, pavan_savoy@sify.com,
        Victor Goldenshtein <victorg@ti.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: Re: [PATCH] drivers:misc:ti-st: fix skip remote baud logic
Message-ID: <20110423054115.GA26504@kroah.com>
References: <1303535297-2586-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303535297-2586-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 10:38:17AM +0530, Pavan Savoy wrote:
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
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> Author:    Victor Goldenshtein <victorg@ti.com>

There is no such thing as an "Author:" tag.

And I know that Victor didn't sign off on this, you can not just add his
name to this like that, it is not allowed.

So I now need to get this patch from Victor, with him confirming that he
has signed off on it, sorry.

greg k-h
