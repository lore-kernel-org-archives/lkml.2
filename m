Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1I1H0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:26:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58944 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1I1H0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:26:02 -0400
MIME-Version: 1.0
In-Reply-To: <1317166015-20714-3-git-send-email-david.daney@cavium.com>
References: <1317166015-20714-1-git-send-email-david.daney@cavium.com> <1317166015-20714-3-git-send-email-david.daney@cavium.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 28 Sep 2011 09:25:42 +0200
Message-ID: <CAHXqBFLzrkH4AJVozbtT4k7ccgVgfaPoq69J48DeSJKSwEtxHw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
To: David Daney <david.daney@cavium.com>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8S7QBST029563

2011/9/28 David Daney <david.daney@cavium.com>:
[...]
> +Example :
> +
> + Â  Â  Â  /* The parent MDIO bus. */
> + Â  Â  Â  smi1: mdio@1180000001900 {
> + Â  Â  Â  Â  Â  Â  Â  compatible = "cavium,octeon-3860-mdio";
> + Â  Â  Â  Â  Â  Â  Â  #address-cells = <1>;
> + Â  Â  Â  Â  Â  Â  Â  #size-cells = <0>;
> + Â  Â  Â  Â  Â  Â  Â  reg = <0x11800 0x00001900 0x0 0x40>;
> + Â  Â  Â  };
> +
> + Â  Â  Â  /*
> + Â  Â  Â  Â  Â An NXP sn74cbtlv3253 dual 1-of-4 switch controlled by a
> + Â  Â  Â  Â  Â pair of GPIO lines. Â Child busses 2 and 3 populated with 4
> + Â  Â  Â  Â  Â PHYs each.
> + Â  Â  Â  Â */
> + Â  Â  Â  mdio-mux {
> + Â  Â  Â  Â  Â  Â  Â  compatible = "cavium,mdio-mux-sn74cbtlv3253", "cavium,mdio-mux";
> + Â  Â  Â  Â  Â  Â  Â  gpios = <&gpio1 3 0>, <&gpio1 4 0>;
> + Â  Â  Â  Â  Â  Â  Â  mdio-parent-bus = <&smi1>;
> + Â  Â  Â  Â  Â  Â  Â  #address-cells = <1>;
> + Â  Â  Â  Â  Â  Â  Â  #size-cells = <0>;

This should probably have 'compatible = "nxp,sn74cbtlv3253";' here.

Best Regards,
MichaÅ‚ MirosÅ‚aw
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
