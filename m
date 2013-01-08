Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153Ab3AHFvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:51:06 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44484 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab3AHFvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:51:04 -0500
Date: Mon, 7 Jan 2013 21:51:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harvey Yang <harvey.huawei.yang@gmail.com>
Cc: Matt Mooney <mfm@muteddisk.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: usbip: use interrupt safe spinlock to avoid
 potential deadlock.
Message-ID: <20130108055128.GA4561@kroah.com>
References: <1357624142-7178-1-git-send-email-harvey.huawei.yang@gmail.com>
 <1357624142-7178-2-git-send-email-harvey.huawei.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357624142-7178-2-git-send-email-harvey.huawei.yang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 01:49:01PM +0800, Harvey Yang wrote:
> 
> Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>

You need to describe _why_ you did this, not just what you did.  Why is
this needed?  What are you fixing by doing this?  Is this something that
older kernels need?  Is it something that others are seeing?

Same goes for patch 2/2 here, you have to provide a good changelog entry
in order for this to be accepted.

thanks,

greg k-h
