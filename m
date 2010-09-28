Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab0I1GGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:06:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36776 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab0I1GGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:06:00 -0400
Date: Tue, 28 Sep 2010 09:05:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Subject: Re: [PATCH v4] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20100928060554.GF2702@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1285618704-8985-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1285618704-8985-1-git-send-email-notasas@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 27, 2010 at 03:18:24PM -0500, Grazvydas Ignotas wrote:
>+static int twl4030_bci_usb_ncb(struct notifier_block *nb, unsigned long val,
>+                              void *priv)
>+{
>+       struct twl4030_bci *bci = container_of(nb, struct twl4030_bci, otg_nb);
>+
>+       dev_dbg(bci->dev, "OTG notify %lu\n", val);
>+
>+       switch (val) {
>+       case USB_EVENT_VBUS:
>+       case USB_EVENT_CHARGER:

you should have removed CHARGER from here :-)

-- 
balbi
