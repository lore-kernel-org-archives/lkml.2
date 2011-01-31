Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab1AaVkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:40:15 -0500
Received: from kroah.org ([198.145.64.141]:54196 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1AaVkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:40:14 -0500
Date: Mon, 31 Jan 2011 13:31:40 -0800
From: Greg KH <greg@kroah.com>
To: Sutharsan <sutharsan.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
Subject: Re: Staging: Westbridge: fix EXPORT_SYMBOL errors reported by
 checkpatch.pl
Message-ID: <20110131213140.GA1671@kroah.com>
References: <1296018202.3623.24.camel@sutharsan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296018202.3623.24.camel@sutharsan-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 09:03:22PM -0800, Sutharsan wrote:
> From: Sutharsan Ramamoorthy <srmt@cypress.com>
> 
> This patch fixes errors reported by checkpatch.pl 
> in westbridge device controller driver in the staging tree.
> File containing EXPORT_SYMBOL() macros for all the APIs exported 
> by the westbridge software has been removed. EXPORT_SYMBOL() 
> macros are added after the corresponding function definitions.
> 
> Signed-off-by: Sutharsan Ramamoorthy <srmt@cypress.com>

I've already applied this patch, and you should have gotten the "this
patch has been applied" email, right?

So why was it resent?

confused,

greg k-h
