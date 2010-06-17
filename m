Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0FQXH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:07:58 -0400
Received: from kroah.org ([198.145.64.141]:42927 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab0FQXHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:07:33 -0400
Date: Thu, 17 Jun 2010 16:05:19 -0700
From: Greg KH <greg@kroah.com>
To: John Sheehan <john.d.sheehan@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, rich.folsom@gmail.com,
       mithlesh@linsyssoft.com, jirislaby@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: fix code warnings in adl_pci9111.c
Message-ID: <20100617230519.GA3717@kroah.com>
References: <1276713044-8534-1-git-send-email-john.d.sheehan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276713044-8534-1-git-send-email-john.d.sheehan@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 07:30:44PM +0100, John Sheehan wrote:
> From: John Sheehan <john.d.sheehan@gmail.com>
> 
> fix some warnings in adl_pci9111.c reported by
> checkpatch.pl tool
> -printk() should include KERN_ facility level
> -no space before tabs
> 
> Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
> ---
>  drivers/staging/comedi/drivers/adl_pci9111.c |   72 ++++++++++++-------------

This patch (and the other one) don't seem to apply anymore.  Care to
redo them against the latest linux-next tree and resend them?

thanks,

greg k-h
