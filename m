Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab2EKMTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:19:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2EKMTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:19:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND v8] gpio: Device tree support for LPC32xx
Date: Fri, 11 May 2012 12:19:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Roland Stigge <stigge@antcom.de>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
References: <1336679838-30738-1-git-send-email-stigge@antcom.de> <20120510234100.7F5463E04A6@localhost>
In-Reply-To: <20120510234100.7F5463E04A6@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205111219.10025.arnd@arndb.de>
X-Provags-ID: V02:K0:MtqkwqcYTYUNS2/h3ujiq+YzZ94WXKqQxnDZnEfQj8g
 gRz6WNkjfsWZx6txY0yPCrCNyoJ7uI640VTeu8bS8TJdjeXlM9
 mtqRTHg945n3BQ35z4TD5Xw+oj5+jVPKPNZbQ4rC29lPTD4Hcg
 WZ1piHiLFLsQaD5IL5PsU797TJGs4WkWTqHCcKUtB0uVKYWLxG
 NGq62ZtsL/JK5hQjzAlefSpx8CaPACsVu7Fn0eOrXGBhEiZHxk
 EQXa+b8Duy/S47GFq7bfc9hCOiwlerBemA2p3/aulhq85zuKa2
 SPo4hCyjifew4FNVN4wqWVlnclYglz603+5naFcVtqJ9a8C/UH
 ZT/xPdgJzNuBEkoVUAxs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2012, Grant Likely wrote:
> How about the following instead (very rough, there should be a cleaner
> way to update the gc pointer in of_xlate):
> 
>         gpio: gpio@40028000 {
>                 compatible = "nxp,lpc3220-gpio";
>                 reg = <0x40028000 0x1000>;
>                 gpio-controller;
>                 #gpio-cells = <3>; /* bank, pin, flags */
>         }
> 

I thought about that when I suggested the current binding to Roland,
but the problem with this is that passing the bank as a number is
not very intuitive when the data sheet has separate number spaces
for gpio, gpi and gpo here, so it seemed more natural to go with what
the data sheet describes.

	Arnd
