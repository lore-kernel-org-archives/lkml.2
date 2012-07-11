Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab2GKPDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:03:35 -0400
Received: from csmtp3.one.com ([91.198.169.23]:36240 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab2GKPDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:03:34 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Wed, 11 Jul 2012 17:03:36 +0200
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-bluetooth@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] USB: add USB_VENDOR_AND_INTERFACE_INFO() macro
Message-ID: <20120711150336.GA1340@polaris.bitmath.org>
References: <1341958206-15610-1-git-send-email-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341958206-15610-1-git-send-email-gustavo@padovan.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 07:10:06PM -0300, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> 
> A lot of Broadcom Bluetooth devices provides vendor specific interface
> class and we are getting flooded by patches adding new device support.
> This change will help us enable support for any other Broadcom with vendor
> specific device that arrives in the future.
> 
> Only the product id changes for those devices, so this macro would be
> perfect for us:
> 
> { USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) }
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> ---

Thank you, Gustavo, this patch made me happy.

Henrik
