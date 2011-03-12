Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1CLRlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 12:41:47 -0500
Received: from kroah.org ([198.145.64.141]:40386 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab1CLRl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 12:41:29 -0500
Date: Sat, 12 Mar 2011 09:42:08 -0800
From: Greg KH <greg@kroah.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        device-driver-devel@blackfin.uclinux.org, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] ad525x_dpot: [BUG] eeprom command send instead
 of dec/inc all commands
Message-ID: <20110312174208.GA32737@kroah.com>
References: <1299935301-3849-1-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299935301-3849-1-git-send-email-richard.genoud@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 02:08:21PM +0100, Richard Genoud wrote:
> When a DEC_ALL or INC_ALL command is issued, an eeprom command is send.
> This is because DPOT_DEC_ALL (DPOT_ADDR_CMD | 0x30) and DPOT_INC_ALL
> (DPOT_ADDR_CMD | 0x58) defines overlap with DPOT_ADDR_EEPROM (0x20).
> 
> So, DPOT_ADDR_CMD bit should be tested before DPOT_ADDR_EEPROM bit.
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  drivers/misc/ad525x_dpot.c |    4 ++--

This is not how you submit a patch for submission to the stable kernel
tree.  Please read Documentation/stable_kernel_rules.txt for how to do
this properly.

thanks,

greg k-h
