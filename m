Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2APK2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:28:17 -0500
Received: from 1.mo1.mail-out.ovh.net ([178.32.127.22]:43043 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753209Ab2APK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:28:15 -0500
X-Greylist: delayed 2400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jan 2012 05:28:15 EST
Message-ID: <4F13E964.5020207@sigfox.com>
Date: Mon, 16 Jan 2012 10:09:56 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0.1) Gecko/20111125 Firefox/8.0.1 SeaMonkey/2.5
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH] watchdog: via_wdt: Staticise wdt_pci_table
References: <1326540874.12848.1.camel@phoenix>
In-Reply-To: <1326540874.12848.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16817566909707044755
X-Ovh-Remote: 92.103.90.130 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefledrudegucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeforghrtgcugggvrhhtvghsuceomhgrrhgtrdhvvghrthgvshesshhighhfohigrdgtohhmqeenucfjughrpefkfffhfgggvffufhgjtgfgsehtjegrtddtfeej
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedrtdekucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthejrgdttdefjeenucfhrhhomhepofgrrhgtucggvghrthgvshcuoehmrghrtgdrvhgvrhhtvghssehsihhgfhhogidrtghomheqnecuffhomhgrihhnpeen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:

> It is only used in this driver, so no need to make the symbol global.
> 

Agree.

Acked-by: Marc Vertes <marc.vertes@sigfox.com>

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/watchdog/via_wdt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
> index 026b4bb..8b24b00 100644
> --- a/drivers/watchdog/via_wdt.c
> +++ b/drivers/watchdog/via_wdt.c
> @@ -233,7 +233,7 @@ static void __devexit wdt_remove(struct pci_dev *pdev)
>  	pci_disable_device(pdev);
>  }
>  
> -DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
> +static DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX800) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },


