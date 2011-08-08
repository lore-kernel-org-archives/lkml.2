Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HHTiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:38:16 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39090 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab1HHTiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:38:14 -0400
X-Sasl-enc: EoJQ8x/IpOTzD51qd4siGEiGq5wqvFninvihMgKChCJR 1312832293
Date: Mon, 8 Aug 2011 12:31:00 -0700
From: Greg KH <greg@kroah.com>
To: Vijay Chavan <vijaychavan007@gmail.com>
Cc: gregkh@suse.de, shardy@redhat.com, mge@arcor.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Serial: Added device ID for Qualcomm Modem in
 Sagemcom's HiLo3G
Message-ID: <20110808193100.GA3416@kroah.com>
References: <1311890983-5506-1-git-send-email-VijayChavan007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311890983-5506-1-git-send-email-VijayChavan007@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 03:39:43AM +0530, Vijay Chavan wrote:
> A new device ID pair is added for Qualcomm Modem present in Sagemcom's HiLo3G module.
> ---
>  drivers/usb/serial/qcserial.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 

Care to resend this with a Signed-off-by: line as required by the file,
Documentation/SubmittingPatches?

thanks,

greg k-h
