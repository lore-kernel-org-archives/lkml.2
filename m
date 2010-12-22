Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0LVOuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:50:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46529 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0LVOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:50:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HSsJG9OgoKwt1Cp7QZ+N98TlD9sIm4vrFcjZT4jckr43ELseXqpV3mAxiX1n5zmXsL
         tY98sRpIlMbnWv7XyMiwyWMik5pXUciU55OqxXLheRYQJMJXkjA77xY/vLiLhjrDKpY+
         +KuRLApPo1iLdJZSsoWM28Ci9H2V5bH8e83EU=
Subject: Re: [PATCH V2 1/2] EHCI support for on-chip PMC MSP USB controller.
From: Anoop P A <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Anatolij Gustschin <agust@denx.de>,
        Anand Gadiyar <gadiyar@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
In-Reply-To: <1293028561-22125-1-git-send-email-anoop.pa@gmail.com>
References: <1292929580-5829-1-git-send-email-anoop.pa@gmail.com>
	 <1293028561-22125-1-git-send-email-anoop.pa@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 20:28:12 +0530
Message-ID: <1293029892.27661.42.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 20:06 +0530, Anoop P.A wrote:
> From: Anoop P A <anoop.pa@gmail.com>
> 
> This patch includes.
> 
> 1. USB host driver for MSP71xx family SoC on-chip USB controller.

>  	ehci_writel(ehci, tmp, reg_ptr);
> +#ifdef CONFIG_USB_EHCI_HCD_PMC_MSP
> +	/* set controller in host mode */
> +	usb_hcd_tdi_set_mode(ehci);
> +#endif

Missed this one while cleaning :( 
>  }


