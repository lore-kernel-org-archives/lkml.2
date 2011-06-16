Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab1FPSWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:22:55 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44588 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757994Ab1FPSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:22:43 -0400
X-Sasl-enc: Rn82h45Fx8Z8cHENUEMOAwItRlvmSTVsWpVBYnFXSQLN 1308248562
Date: Thu, 16 Jun 2011 11:21:41 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        Amit Blay <ablay@qualcomm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to
 devio.c
Message-ID: <20110616182141.GC1439@kroah.com>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
 <1308231068-24038-6-git-send-email-tlinder@codeaurora.org>
 <20110616162839.GY12230@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616162839.GY12230@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 07:28:40PM +0300, Felipe Balbi wrote:
> On Thu, Jun 16, 2011 at 04:31:07PM +0300, Tatyana Brokhman wrote:
> > Allow user space applications such as LIBUSB, to request
> > streams alloc/dealloc from HCD that implements XHCI.
> > 
> > Signed-off-by: Amit Blay <ablay@qualcomm.com>
> > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> other than what Alan said, this needs major splitting. This patch is too
> big. First we need to discuss the ABI details with the guys at
> libusb-devel, then we implement.

No, we don't break the abi, but rather, create a new one for streams,
and then we can work on adding them to libusb, which should be quite
easy when done.

thanks,

greg k-h
