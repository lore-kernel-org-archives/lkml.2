Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1EJW5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:57:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37680 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab1EJW5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P/847x7odODDmX3bPMhpIm6e9QrBVm6U9+5maNGStWuHbfm7tj4RqGqCE/RIB1szrT
         tD2od68qOquqf9TE9gs1mfODSZT/goZsxougdtcq1JLEjuxW/StOjVwL9K9sPxAiyxhe
         PHKf92gBb5KkxrI1Dv/f6I0pNx2u+7DphGYgc=
MIME-Version: 1.0
In-Reply-To: <1304287825-8023-1-git-send-email-tfransosi@gmail.com>
References: <1304287825-8023-1-git-send-email-tfransosi@gmail.com>
Date: Tue, 10 May 2011 19:57:13 -0300
Message-ID: <BANLkTim+Oah2dg2hazHU0wuxzJCiEy3Rmw@mail.gmail.com>
Subject: Re: [PATCH] ide/ide-scan-pci.c: Use for_each_pci_dev().
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Sun, May 1, 2011 at 7:10 PM, Thiago Farina <tfransosi@gmail.com> wrote:
> Use for_each_pci_dev() to simplify the code.
>
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/ide/ide-scan-pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
> index 0e79eff..c3da53e 100644
> --- a/drivers/ide/ide-scan-pci.c
> +++ b/drivers/ide/ide-scan-pci.c
> @@ -88,7 +88,7 @@ static int __init ide_scan_pcibus(void)
>        struct list_head *l, *n;
>
>        pre_init = 0;
> -       while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)))
> +       for_each_pci_dev(dev)
>                ide_scan_pcidev(dev);
>
>        /*
> --
> 1.7.5.rc2.5.g60e19
>
>
