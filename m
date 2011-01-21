Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1AUUqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:46:33 -0500
Received: from kroah.org ([198.145.64.141]:38344 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab1AUUq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:46:29 -0500
Date: Fri, 21 Jan 2011 12:40:13 -0800
From: Greg KH <greg@kroah.com>
To: Sutharsan Ramamoorthy <sutharsan.ramamoorthy@yahoo.com>
Cc: tony@atomide.com, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
Subject: Re: Staging: Westbridge: fix EXPORT_SYMBOL errors reported by
 checkpatch.pl
Message-ID: <20110121204012.GA28267@kroah.com>
References: <444938.26253.qm@web121610.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444938.26253.qm@web121610.mail.ne1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 05:31:46PM -0800, Sutharsan Ramamoorthy wrote:
> From: Sutharsan Ramamoorthy <srmt@cypress.com>
> 
> This patch fixes errors in westbridge device controller driver in the 
> staging tree reported by checkpatch.pl. File containing EXPORT_SYMBOL() 
> macros for all the APIs exported by the westbridge software has been removed. EXPORT_SYMBOL() macros are added after the corresponding function definitions.
> 
> Signed-off-by: Sutharsan Ramamoorthy <srmt@cypress.com>

This patch is corrupted and can't be applied.  Perhaps it's due to the
mime encoding?

Anyway, care to fix your email client and resend it so that I can apply
it?

thanks,

greg k-h
