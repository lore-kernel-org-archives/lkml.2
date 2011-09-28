Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1I1Wi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1I1Wi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:26 2011
Message-Id: <20110928220126.210372271@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Alan Cox <alan@linux.intel.com>
Subject: [009/244] serial: 8250_pnp: add Intermec CV60 touchscreen device
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit ab8ba3a2d2cba6a658ef596cd5b2e0905b6c8a9f upstream.

It would have been nice if Intermec had supplied a PNP0501 _CID for the
COM3 device, but they didn't, so we have to recognize it explicitly.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=40612
CC: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/8250_pnp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/8250_pnp.c
+++ b/drivers/tty/serial/8250_pnp.c
@@ -109,6 +109,9 @@ static const struct pnp_device_id pnp_de
 	/* IBM */
 	/* IBM Thinkpad 701 Internal Modem Voice */
 	{	"IBM0033",		0	},
+	/* Intermec */
+	/* Intermec CV60 touchscreen port */
+	{	"PNP4972",		0	},
 	/* Intertex */
 	/* Intertex 28k8 33k6 Voice EXT PnP */
 	{	"IXDC801",		0	},


