Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0JLSEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:04:40 -0400
Received: from kroah.org ([198.145.64.141]:37733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0JLSEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:04:39 -0400
Date: Tue, 12 Oct 2010 11:02:27 -0700
From: Greg KH <greg@kroah.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, "Govindraj.R" <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: omap-serial: fix signess error
Message-ID: <20101012180227.GA11846@kroah.com>
References: <1286731715-17908-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286731715-17908-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 09:28:35PM +0400, Vasiliy Kulikov wrote:
> "ret" is unsigned, so check for (ret < 0) made no sense.
> Made it signed.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  I cannot compile this driver, so it is not tested.
> 
>  drivers/serial/omap-serial.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

This seems to be in the omap tree, and not in my tree, so you will need
to push this through the omap maintainers.

thanks,

greg k-h
