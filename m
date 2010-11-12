Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab0KLPEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:04:12 -0500
Received: from kroah.org ([198.145.64.141]:41475 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100Ab0KLPEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:04:11 -0500
Date: Fri, 12 Nov 2010 07:01:43 -0800
From: Greg KH <greg@kroah.com>
To: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm@lists.arm.linux.org.uk, linux-serial@vger.kernel.org
Subject: Re: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
Message-ID: <20101112150143.GA18096@kroah.com>
References: <1289567043-6213-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289567043-6213-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 03:03:59PM +0200, Emeltchenko Andrei wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
> 
> Add MDR1 Serial register definition to serial_reg and remove duplicated
> code, remove magic MDR1 register numbers from serial drivers.
> 
> *v2 add OMAP keyword to MDR1 definition
> *v3 remove magic from serial drivers
> *v4 taking comments from Manjunath and Govindraj: typos, CC
> 
> Andrei Emeltchenko (4):
>   OMAP: Serial: Define OMAP uart MDR1 register definitions
>   OMAP1: Serial: remove magic numbers for MDR1 reg
>   OMAP2: Serial: remove magic numbers for MDR1 reg
>   OMAP: Serial: remove redefined MDR1 register definitions

Looks good, do you want these to go through the omap tree, or the serial
tree?

If they go through the omap tree, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
