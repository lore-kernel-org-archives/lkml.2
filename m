Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0KIVOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:14:52 -0500
Received: from kroah.org ([198.145.64.141]:54278 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab0KIVOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:14:51 -0500
Date: Tue, 9 Nov 2010 13:14:18 -0800
From: Greg KH <greg@kroah.com>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/6] serial/ce4100: Add PCI UART support for the ce4100
Message-ID: <20101109211418.GA15802@kroah.com>
References: <cover.1289331834.git.dirk.brandewie@gmail.com>
 <654d0e8f80dd959fd9c871ad1644126d58b2445b.1289331834.git.dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <654d0e8f80dd959fd9c871ad1644126d58b2445b.1289331834.git.dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:08:06PM -0800, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> This patch adds support for the PCI UART on the ce4100.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> CC: linux-serial@vger.kernel.org
> ---
>  drivers/serial/8250_pci.c |   35 +++++++++++++++++++++++++++++++++++
>  include/linux/pci_ids.h   |    1 +

You did read the top of pci_ids.h right?  Why are you adding new ids
that are only used by one file?

Please don't do that.

thanks,

greg k-h
