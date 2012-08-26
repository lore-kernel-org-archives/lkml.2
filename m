Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2HZRLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 13:11:49 -0400
Received: from senator.holtmann.net ([87.106.208.187]:56530 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2HZRLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 13:11:47 -0400
Message-ID: <1346000930.1779.29.camel@aeonflux>
Subject: Re: [PATCH] Bluetooth: Add support for Apple vendor-specific devices
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 26 Aug 2012 10:08:50 -0700
In-Reply-To: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
References: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

> As pointed out by Gustavo and Marcel, all Apple-specific Broadcom
> devices seen so far have the same interface class, subclass and
> protocol numbers. This patch adds an entry which matches all of them,
> using the new USB_VENDOR_AND_INTERFACE_INFO() macro.
> 
> In particular, this patch adds support for the MacBook Pro Retina
> (05ac:8286), which is not in the present list.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Gustavo,
> 
> here is a patch for the Apple devices, utilizing commit d81a5d19, for
> 3.6. Tested on the MacBookPro10,1 (Retina). If you want, I can
> follow-up with a patch for 3.7 which removes the specific entries. I
> have verified the lsusb output of all of them, except MacMini5,1.
> 
> Thanks,
> Henrik
> 
>  drivers/bluetooth/btusb.c | 3 +++
>  1 file changed, 3 insertions(+)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


