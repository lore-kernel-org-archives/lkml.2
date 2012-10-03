Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab2JCSaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:30:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64084 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab2JCSaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:30:18 -0400
From: Florian Fainelli <florian@openwrt.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/25] MIPS: Octeon: use ehci-platform driver
Date: Wed, 03 Oct 2012 20:30:13 +0200
Message-ID: <3792469.SZIVmLSlNr@bender>
Organization: OpenWrt
User-Agent: KMail/4.8.5 (Linux/3.2.0-31-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <506C6BBC.7090806@gmail.com>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org> <1349276601-8371-10-git-send-email-florian@openwrt.org> <506C6BBC.7090806@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2012 09:45:48 David Daney wrote:
> On 10/03/2012 08:03 AM, Florian Fainelli wrote:
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> > ---
> >   arch/mips/cavium-octeon/octeon-platform.c |   43 
++++++++++++++++++++++++++++-
> >   1 file changed, 42 insertions(+), 1 deletion(-)
> 
> 
> NACK.
> 
> OCTEON uses device tree now (or as soon as I send in the corresponding 
> patches), so this would just be churning the code.

Please send the changes to enable Device Tree for EHCI and OHCI, and when both 
platform drivers get Device Tree capability we can easily change them.
-- 
Florian
