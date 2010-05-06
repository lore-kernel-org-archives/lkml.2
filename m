Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0EFSj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:39:57 -0400
Received: from web51006.mail.re2.yahoo.com ([206.190.38.137]:40604 "HELO
	web51006.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751324Ab0EFSj4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:39:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=mH3zW/IhEef2g5VX3j2SPjDmexpSbOEDgqcYuzYLasEGTE6qwugSpZemRI+pTj6GP2gr08aHP1lVVwdDs/ZO+bEQ9DCofFI9VdrV0g4j3TuFY05Khy29CpYzcuavzSF9RZlTd1jArzT2IE3oc9Ko+pqryfKgVZo/9cM3jFN3cyw=;
Message-ID: <501887.6368.qm@web51006.mail.re2.yahoo.com>
X-YMail-OSG: dcKZIGQVM1nDI2.cZHbZP13lvWC0Y4NUR2FRTHAPOsR86q_
 dYAFdzj_uT3qEOKw9PoGSl0FVxXJzrffHUoIRxoDwlfysQwuGAni.NamhmNN
 gOyjEzfdHKItgOXKJ4zRBHi7qyZ0iUuCPH7F6PeAwML13ADP6XWp40tGbFMh
 fdwzIIVdTIqeniRaHDYEv5NksiVJi4xcvLev3m4CwOQnsuH9Lpw8soG2tZn0
 1NH1ASVObr8yNwcMROFsTZVA8qevCZTkSErvmFK4BUoLhcUh.Sy_U_qn9EB0
 GI7r89idDJeGYOEeoan4PcXXpuOpr0cRlzU0Btih7A7lJwacf6Jo-
X-Mailer: YahooMailClassic/10.1.11 YahooMailWebService/0.8.103.269680
Date: Thu, 6 May 2010 11:33:15 -0700 (PDT)
From: Fabio Estevam <fabioestevam@yahoo.com>
Subject: Re: [PATCHv1 2.6.34-rc6 1/3] mxc: gadget: remove 60mhz clock requirement for freescale mx51 usb core
To: linux-kernel@vger.kernel.org, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Cc: amit.kucheria@canonical.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>,
       s.hauer@pengutronix.de, linux-usb@vger.kernel.org, Jun.Li@freescale.com,
       grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
       daniel@caiaq.de, bryan.wu@canonical.com, xiao-lizhang@freescale.com,
       valentin.longchamp@epfl.ch
In-Reply-To: <1273100171-3235-2-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 5/5/10, Dinh Nguyen <Dinh.Nguyen@freescale.com> wrote:

> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> Subject: [PATCHv1 2.6.34-rc6 1/3] mxc: gadget: remove 60mhz clock requirement for freescale mx51 usb core
> To: linux-kernel@vger.kernel.org
> Cc: amit.kucheria@canonical.com, "Dinh Nguyen" <Dinh.Nguyen@freescale.com>, s.hauer@pengutronix.de, linux-usb@vger.kernel.org, Jun.Li@freescale.com, grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org, daniel@caiaq.de, bryan.wu@canonical.com, xiao-lizhang@freescale.com, valentin.longchamp@epfl.ch
> Date: Wednesday, May 5, 2010, 7:56 PM
> for mx51, usb core is clocked from
> sources that are not 60mhz.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  drivers/usb/gadget/fsl_mx3_udc.c |   14
> ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/gadget/fsl_mx3_udc.c
> b/drivers/usb/gadget/fsl_mx3_udc.c
> index 20a802e..d0b8bde 100644
> --- a/drivers/usb/gadget/fsl_mx3_udc.c
> +++ b/drivers/usb/gadget/fsl_mx3_udc.c

Shouldn't this file be renamed to fsl_mx_udc.c ?

fsl_mx3_udc.c suggests that it applies for MX31/MX35 processors.

Regards,

Fabio Estevam


      
