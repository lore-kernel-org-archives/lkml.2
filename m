Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147Ab0GPA50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:57:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41405 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935102Ab0GPA5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FKyaEC8welfPy3PfjSbdRE2pIzTR9750MqcH+eY2J2hodY3ZOhQIdnwdHEqwFYV1Qx
         SDUhj7jxQqjA0yREpXHdadQFC6PjBG12U3UG3w7opdnrT6EghPAsj8Gvww9RqARq4jnz
         sY2w8TTHn6KyzBC1HvC8O2MXHACpT4iFfPriQ=
Message-ID: <4C3FAE6F.3020406@garzik.org>
Date: Thu, 15 Jul 2010 20:57:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joseph Kogut <joseph.kogut@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: net: 8139cp: Fixed 28 style errors, and 119
  warnings.
References: <AANLkTikspw9LxFFsXJgWn30k2qCVu5zkOAq2FhWTpQvW@mail.gmail.com>
In-Reply-To: <AANLkTikspw9LxFFsXJgWn30k2qCVu5zkOAq2FhWTpQvW@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -/* The following settings are log_2(bytes)-4:  0 == 16 bytes .. 6==1024, 7==end of packet. */
> -#define RX_FIFO_THRESH         5       /* Rx buffer level before first PCI xfer.  */
> +/* The following settings are log_2(bytes)-4:  0 == 16 bytes .. 6 == 1024, 7 == end of packet. */
> +#define RX_FIFO_THRESH         5       /* Rx buffer level before first PCI xfer. */

useless noise

> -       unsigned                wol_enabled : 1; /* Is Wake-on-LAN enabled? */
> +       unsigned                wol_enabled:1; /* Is Wake-on-LAN enabled? */

not an improvement

> -               if (wol->wolopts & WAKE_PHY)    options |= LinkUp;
> -               if (wol->wolopts & WAKE_MAGIC)  options |= MagicPacket;
> +               if (wol->wolopts & WAKE_PHY)
> +                       options |= LinkUp;
> +               if (wol->wolopts & WAKE_MAGIC)
> +                       options |= MagicPacket;

ditto

> -               if (wol->wolopts & WAKE_UCAST)  options |= UWF;
> -               if (wol->wolopts & WAKE_BCAST)  options |= BWF;
> -               if (wol->wolopts & WAKE_MCAST)  options |= MWF;
> +               if (wol->wolopts & WAKE_UCAST)
> +                       options |= UWF;
> +               if (wol->wolopts & WAKE_BCAST)
> +                       options |= BWF;
> +               if (wol->wolopts & WAKE_MCAST)
> +                       options |= MWF;

ditto
>
> -       if (options & UWF)           wol->wolopts |= WAKE_UCAST;
> -       if (options & BWF)           wol->wolopts |= WAKE_BCAST;
> -       if (options & MWF)           wol->wolopts |= WAKE_MCAST;
> +       options        = cpr8(Config5);
> +       if (options & UWF)
> +               wol->wolopts |= WAKE_UCAST;
> +       if (options & BWF)
> +               wol->wolopts |= WAKE_BCAST;
> +       if (options & MWF)
> +               wol->wolopts |= WAKE_MCAST;

ditto

