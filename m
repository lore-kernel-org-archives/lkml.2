Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab0LPSRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:17:07 -0500
Received: from kroah.org ([198.145.64.141]:59438 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0LPSRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:17:03 -0500
Date: Thu, 16 Dec 2010 10:15:25 -0800
From: Greg KH <greg@kroah.com>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH v2] usb: Add streams support to epautoconf.
Message-ID: <20101216181525.GB19012@kroah.com>
References: <1292484860-26047-1-git-send-email-merez@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292484860-26047-1-git-send-email-merez@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 09:34:19AM +0200, Maya Erez wrote:
> - Add the capability to search for an EP with a required number of streams.
> - Add a gadget_op to allow DCDs to use a proprietary search algorithm
> for required and minimum number of streams.

What do you exactly mean by "proprietary search algorithm"?

thanks,

greg k-h
