Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256Ab1D1TxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 15:53:12 -0400
Received: from kroah.org ([198.145.64.141]:34068 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab1D1TxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 15:53:08 -0400
Date: Thu, 28 Apr 2011 12:47:25 -0700
From: Greg KH <greg@kroah.com>
To: Sutharsan <sutharsan.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
Subject: Re: [PATCH] Staging: Westbridge: replace custom debug macros with
 pr_...() macros
Message-ID: <20110428194725.GB25302@kroah.com>
References: <1304016521.3749.13.camel@sutharsan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304016521.3749.13.camel@sutharsan-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 11:48:41AM -0700, Sutharsan wrote:
> >From Sutharsan Ramamoorthy <srmt@cypress.com>
> 
> This patch replaces custom debug macros with Linux kernel's pr_...() macros.

Why not use the dev_dbg() and other macros instead of these?  You do
have access to a struct device for all of these places in the code,
right?

thanks,

greg k-h
