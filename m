Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab0KOUy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:54:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39543 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753616Ab0KOUy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:54:56 -0500
Date: Mon, 15 Nov 2010 15:54:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joe Perches <joe@perches.com>
cc: Jiri Kosina <trivial@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] drivers/usb/host/uhci-hcd.c: Remove unnecessary
 casts of pci_get_drvdata
In-Reply-To: <1a734720c779c15cc09e1fb5e757f24c96196ca7.1289851770.git.joe@perches.com>
Message-ID: <Pine.LNX.4.44L0.1011151554360.1370-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/usb/host/uhci-hcd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
> index f52d04d..cee8678 100644
> --- a/drivers/usb/host/uhci-hcd.c
> +++ b/drivers/usb/host/uhci-hcd.c
> @@ -569,7 +569,7 @@ static int uhci_init(struct usb_hcd *hcd)
>   */
>  static void uhci_shutdown(struct pci_dev *pdev)
>  {
> -	struct usb_hcd *hcd = (struct usb_hcd *) pci_get_drvdata(pdev);
> +	struct usb_hcd *hcd = pci_get_drvdata(pdev);
>  
>  	uhci_hc_died(hcd_to_uhci(hcd));
>  }

Acked-by: Alan Stern <stern@rowland.harvard.edu>


