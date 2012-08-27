Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2H0Nif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 09:38:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60950 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2H0Nid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 09:38:33 -0400
Date: Mon, 27 Aug 2012 08:38:22 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add support for Apple vendor-specific devices
Message-ID: <20120827133822.GA7740@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Henrik Rydberg <rydberg@euromail.se>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

* Henrik Rydberg <rydberg@euromail.se> [2012-08-25 19:28:06 +0200]:

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

Patch has been applied to the bluetooth tree. Thanks.

	Gustavo
