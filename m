Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab2INORY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:17:24 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23749 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2INORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:17:21 -0400
Date: Fri, 14 Sep 2012 17:16:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navinp@cdac.in>
Cc: gregkh@linuxfoundation.org, mfm@muteddisk.com, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of
 usbip_host
Message-ID: <20120914141638.GF4587@mwanda>
References: <1347628893-8223-1-git-send-email-navinp@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347628893-8223-1-git-send-email-navinp@cdac.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 06:51:33PM +0530, navin patidar wrote:
> stub_device_reset should set kernel thread pointers to NULL.
> so that at the time of usbip_host removal stub_shoutdown_connection
> doesn't try to kill kernel threads which are already killed.
> 

If you wanted to put a sample Oops stack trace in here, that would
always be welcome.  It's not something to resend over.  Just an
idea.

> -------------------------------------------------------------------------------------------------------------------------------
> 
> This e-mail is for the sole use of the intended recipient(s) and may
> contain confidential and privileged information. If you are not the
> intended recipient, please contact the sender by reply e-mail and destroy
> all copies and the original message. Any unauthorized review, use,
> disclosure, dissemination, forwarding, printing or copying of this email
> is strictly prohibited and appropriate legal action will be taken.
> -------------------------------------------------------------------------------------------------------------------------------

I don't think this text is allowed on patches.  This is a thing
where you probably will need to resend the patch.

regards,
dan carpenter

