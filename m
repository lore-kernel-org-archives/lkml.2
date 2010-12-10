Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0LJXO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:14:58 -0500
Received: from kroah.org ([198.145.64.141]:56643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab0LJXO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:14:57 -0500
Date: Fri, 10 Dec 2010 15:12:54 -0800
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core: document restrictions on device_rename()
Message-ID: <20101210231254.GA9845@kroah.com>
References: <1291246854-19283-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291246854-19283-1-git-send-email-timur@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 05:40:54PM -0600, Timur Tabi wrote:
> Add text, courtesy of Kay Sievers, that provides some background on
> device_rename() and why it shouldn't be used.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>  drivers/base/core.c |   28 ++++++++++++++++++++++++++++

This patch doesn't apply to the linux-next branch, care to refresh it so
I can apply it?

thanks,

greg k-h
