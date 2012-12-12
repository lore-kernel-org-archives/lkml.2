Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab2LLGfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:35:37 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40435 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2LLGfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:35:36 -0500
Date: Tue, 11 Dec 2012 20:45:22 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Stephen Hurd <shurd@broadcom.com>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 8250/16?50: Add support for Broadcom TruManage
 redirected serial port
Message-ID: <20121212044522.GA7224@kroah.com>
References: <156984479488CD49A184F5CAB4AF934606FF55F8@IRVEXCHMB14.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156984479488CD49A184F5CAB4AF934606FF55F8@IRVEXCHMB14.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 01:11:47AM +0000, Stephen Hurd wrote:
> It appears that the modification to include/uapi/linux/serial_core.h is excluded by the dontdiff filters.  I've attached an updated patch including it.

Care to resend the whole thing, I need it with the signed-off-by: line.

Also, base64 attachments really don't work well, if at all.  You might
be forced to use Outlook, but Exchange can send patches if you configure
it properly.  Please talk to your Broadcom coworkers for how to do this
properly, they know how to do it.

thanks,

greg k-h
