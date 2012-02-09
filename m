Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2BIKw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:52:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51266 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2BIKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:52:58 -0500
Message-ID: <4F33A540.7020906@mvista.com>
Date: Thu, 09 Feb 2012 14:51:44 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: netdev@vger.kernel.org, Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/50] smsc95xx: use dev_hw_addr_random() instead of random_ether_addr()
References: <1328735457-29986-1-git-send-email-danny.kukawka@bisect.de> <1328735457-29986-3-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1328735457-29986-3-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-02-2012 1:10, Danny Kukawka wrote:

> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.

> Signed-off-by: Danny Kukawka<danny.kukawka@bisect.de>
> ---
>   drivers/net/usb/smsc95xx.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index d45520e..3a28e95 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -614,7 +614,7 @@ static void smsc95xx_init_mac_address(struct usbnet *dev)
>   	}
>
>   	/* no eeprom, or eeprom values are invalid. generate random MAC */
> -	random_ether_addr(dev->net->dev_addr);
> +	dev_hw_addr_random(dev->net , dev->net->dev_addr);

    Should be no space before comma.

WBR, Sergei
