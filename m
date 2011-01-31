Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab1AaVq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:46:28 -0500
Received: from kroah.org ([198.145.64.141]:57747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab1AaVq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:46:26 -0500
Date: Mon, 31 Jan 2011 13:40:32 -0800
From: Greg KH <greg@kroah.com>
To: Sutharsan <sutharsan.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
Subject: Re: [PATCH] Staging: Westbridge: fix EXPORT_SYMBOL errors reported
 by checkpatch.pl
Message-ID: <20110131214032.GB1629@kroah.com>
References: <1296061134.4116.7.camel@sutharsan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296061134.4116.7.camel@sutharsan-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:58:54AM -0800, Sutharsan wrote:
> 
> From: Sutharsan Ramamoorthy <srmt@cypress.com>
> 
> This patch fixes errors reported by checkpatch.pl
> in westbridge device controller driver in the staging tree.
> File containing EXPORT_SYMBOL() macros for all the APIs exported
> by the westbridge software has been removed. EXPORT_SYMBOL() 
> macros are added after the corresponding function definitions.
> 
> Signed-off-by: Sutharsan Ramamoorthy <srmt@cypress.com>

Why was this sent again?

totally confused,

greg k-h
