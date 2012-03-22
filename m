Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031123Ab2CVVbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:31:18 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53658 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031055Ab2CVVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:31:15 -0400
X-Authenticated: #9008106
X-Provags-ID: V01U2FsdGVkX19lYcIENF1llWxUdmE/NQ4AvlGdZlAColoSKPhcTy
	Kx0FCv2IcUJ5VV
Date: Thu, 22 Mar 2012 22:31:12 +0100
From: Michael Brunner <mibru@gmx.de>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] pch_uart: Add Kontron COMe-mTT10 uart clock quirk
Message-ID: <20120322223112.291e0c59@mail.gmx.de>
In-Reply-To: <4F6B8E1B.9080802@linux.intel.com>
References: <20120322211903.6776ab18@mail.gmx.de>
	<4F6B8E1B.9080802@linux.intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These boards should already be supported by the following BIOS check.
> As the DMI_BOARD_NAME was changing, it was Kontron's recommendation
> to use the FRI2 prefix in the DMI_BIOS_VERSION.
> 
> 
> >  	cmp = dmi_get_system_info(DMI_BIOS_VERSION);
> >  	if (cmp && strnstr(cmp, "FRI2", 4))
> 
> Is this not working for you? If not, what is the DMI_BIOS_VERSION
> reported by your board?
>
> And for clarification, we are talking about this right:
> http://us.kontron.com/products/systems+and+platforms/m2m/m2m+smart+services+developer+kit.html

My changes refer to the embedded module with the project code NTC1:
<http://us.kontron.com/products/computeronmodules/com+express/com+express+mini/comemtt10.html>

So unfortunately the FRI2 checks won't work for this.

Michael
