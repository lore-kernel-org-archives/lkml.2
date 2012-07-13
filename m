Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2GMHPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 03:15:11 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40023 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2GMHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 03:15:09 -0400
MIME-Version: 1.0
In-Reply-To: <93ab9a323e85d1b0d8c7eac4db7ab7835e61efe6.1342157022.git.joe@perches.com>
References: <cover.1342157022.git.joe@perches.com>
	<1341968967.13724.23.camel@joe2Laptop>
	<93ab9a323e85d1b0d8c7eac4db7ab7835e61efe6.1342157022.git.joe@perches.com>
Date: Fri, 13 Jul 2012 09:15:06 +0200
Message-ID: <CAL1gcdP+USKVTpQ1+UeLj5VBRtpchCHjP=B=HATpW483f5bCYA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] wireless: Use eth_random_addr
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 7:33 AM, Joe Perches <joe@perches.com> wrote:
> Convert the existing uses of random_ether_addr to
> the new eth_random_addr.
>
> Signed-off-by: Joe Perches <joe@perches.com>

For the rt2x00 parts:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/adm8211.c             |    2 +-
>  drivers/net/wireless/p54/eeprom.c          |    2 +-
>  drivers/net/wireless/rt2x00/rt2400pci.c    |    2 +-
>  drivers/net/wireless/rt2x00/rt2500pci.c    |    2 +-
>  drivers/net/wireless/rt2x00/rt2500usb.c    |    2 +-
>  drivers/net/wireless/rt2x00/rt2800lib.c    |    2 +-
>  drivers/net/wireless/rt2x00/rt61pci.c      |    2 +-
>  drivers/net/wireless/rt2x00/rt73usb.c      |    2 +-
>  drivers/net/wireless/rtl818x/rtl8180/dev.c |    2 +-
>  drivers/net/wireless/rtl818x/rtl8187/dev.c |    2 +-
>  10 files changed, 10 insertions(+), 10 deletions(-)
>

---
Gertjan
