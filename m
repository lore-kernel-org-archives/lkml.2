Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1FML46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:56:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56195 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1FML45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=HIjxmRIMrlLjbJ+BS6AJZGoAP4sZTFNltE9SeoJl9i7dkLDVDaFXLD6KPrqum+WA29
         j44hqn+DLzgkUpTi+686VYaVcDDNHCWJnvfN8PV7B+p62hTitKwz+i1GrQ3MU07ylVs7
         TgcMTAzWnmDIhEGMfX64byr+tNJI1Nqm3lIA4=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <20110613114825.7515.15493.stgit@localhost6>
References: <20110613114825.7515.15493.stgit@localhost6>
Date: Mon, 13 Jun 2011 19:56:55 +0800
X-Google-Sender-Auth: nThhE1H7NYR5G_ebDgDatQSlUsw
Message-ID: <BANLkTinKFjxWFP6j179cZjthQKcDJ626OA@mail.gmail.com>
Subject: Re: [PATCH] serial: fix warning in 8250_pci
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/11, Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:
> fix trivial "initialization from incompatible pointer type" warning
> introduced by v2.6.39-rc4-48-gd9a0fbf
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  drivers/tty/serial/8250_pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
> index 4b4968a..78e98a5 100644
> --- a/drivers/tty/serial/8250_pci.c
> +++ b/drivers/tty/serial/8250_pci.c
> @@ -973,7 +973,7 @@ ce4100_serial_setup(struct serial_private *priv,
>
>  static int
>  pci_omegapci_setup(struct serial_private *priv,
> -		      struct pciserial_board *board,
> +		      const struct pciserial_board *board,
>  		      struct uart_port *port, int idx)
>  {
>  	return setup_port(priv, port, 2, idx * 8, 0);
>
It's already in greg's tree.
http://git.kernel.org/?p=linux/kernel/git/gregkh/tty-2.6.git;a=commitdiff;h=1798ca13bfae8cc7c0ef82c034c3c4951ecaeb88

Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
