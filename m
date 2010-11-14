Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0KNS3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 13:29:17 -0500
Received: from kroah.org ([198.145.64.141]:60955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab0KNS3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 13:29:15 -0500
Date: Sun, 14 Nov 2010 10:29:15 -0800
From: Greg KH <greg@kroah.com>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>, Cliff Cai <cliff.cai@analog.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] usb: Add streams support to epautoconf.
Message-ID: <20101114182915.GA20922@kroah.com>
References: <1289715812-29000-1-git-send-email-merez@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289715812-29000-1-git-send-email-merez@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 08:23:20AM +0200, Maya Erez wrote:
> +	/* Get the number of required streams from the EP companion
> +	 * descriptor and see if the EP matches it
> +	 */

Close, but this isn't the proper format for multi-line comments in the
kernel.  Please fix this.

> +	if (USB_ENDPOINT_XFER_BULK == type) {

Ick, no, don't do comparisons like this.  The compiler will let you know
if you acidentally get it wrong with only one '=' character, don't do
things "backward" like this just to work around stupid compilers.

thanks,

greg k-h
