Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1HBVoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:44:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58581 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1HBVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:44:32 -0400
Message-ID: <4E386FB9.2040507@lwfinger.net>
Date: Tue, 02 Aug 2011 16:44:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8192cu: add USB ID for Belkin n300 Micro USB wireless
 adapter
References: <201108022229.58532.s.L-H@gmx.de> <201108022243.04377.s.L-H@gmx.de>
In-Reply-To: <201108022243.04377.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 03:43 PM, Stefan Lippers-Hollmann wrote:
> Hi
>
> On Tuesday 02 August 2011, Stefan Lippers-Hollmann wrote:
>> Signed-off-by: Stefan Lippers-Hollmann<s.l-h@gmx.de>
>> Cc: stable<stable@kernel.org>  [2.6.39+]
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    3 +++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>> @@ -322,6 +322,9 @@ static struct usb_device_id rtl8192c_usb
>>   	{RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
>>   	{RTL_USB_DEVICE(0x2019, 0xab2b, rtl92cu_hal_cfg)}, /*Planex -Abocom*/
>>   	{RTL_USB_DEVICE(0x7392, 0x7822, rtl92cu_hal_cfg)}, /*Edimax -Edimax*/
>> +
>> +	/****** 8192CUS Dongle ********/
>> +	{RTL_USB_DEVICE(0x050D, 0x2103, rtl92cu_hal_cfg)}, //Belkin - Edimax
>>   	{}
>>   };
>
> Looking at the current(?) vendor driver
> 4309c61f45497de0241781a507df53e4 *RTL8192CU_linux_v3.0.2164.20110715.zip
> there appear to be several more USB IDs which might be worth adding; so
> far I only submitted a patch for a tested USB ID.
>
> I've dropped IDs already present in rtl8192cu, the two lines starting
> with '!' appear to be typos in either of the drivers:
>
> #ifdef CONFIG_RTL8192C
>          /*=== Realtek demoboard ===*/
>
>          /****** 8188CUS ********/
>          {USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817F)},//8188RU
>
>          /****** 8192CUS ********/
>          {USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8178)},//8192cu 2*2
>          {USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8186)},//8192CE-VAU USB minCard
>
>          /*=== Customer ID ===*/
>          /****** 8188CUS Dongle ********/
>          {USB_DEVICE(0x4855, 0x0090)},// - Feixun
>          {USB_DEVICE(0x13D3, 0x3357)},// - AzureWave
>          {USB_DEVICE(0x0DF6, 0x005C)},//Sitecom - Edimax
>          {USB_DEVICE(0x0BDA, 0x5088)},//Thinkware - CC&C
>          {USB_DEVICE(0x4856, 0x0091)},//NetweeN - Feixun
>          {USB_DEVICE(0x9846, 0x9041)},//Netgear - Cameo
>          {USB_DEVICE(0x2019, 0x4902)},//Planex - Etop
>          {USB_DEVICE(0x2019, 0xAB2E)},//SW-WF02-AD15 -Abocom
>
>          /****** 8188CE-VAU ********/
> !       {USB_DEVICE(0x13D3, 0x3359)},// - Azwave
> !       {USB_DEVICE(0x13D3, 0x3358)},// - Azwave
>
>          /****** 8188CUS Slim Solo********/
>          {USB_DEVICE(0x04F2, 0xAFF7)},//XAVI - XAVI
>          {USB_DEVICE(0x04F2, 0xAFF9)},//XAVI - XAVI
>          {USB_DEVICE(0x04F2, 0xAFFA)},//XAVI - XAVI
>
>          /****** 8188CUS Slim Combo ********/
>          {USB_DEVICE(0x04F2, 0xAFF8)},//XAVI - XAVI
>          {USB_DEVICE(0x04F2, 0xAFFB)},//XAVI - XAVI
>          {USB_DEVICE(0x04F2, 0xAFFC)},//XAVI - XAVI
>          {USB_DEVICE(0x2019, 0x1201)},//Planex - Vencer
>
>          /****** 8192CUS Dongle ********/
>          {USB_DEVICE(0x4855, 0x0091)},// - Feixun
>          {USB_DEVICE(0x050D, 0x2102)},//Belkin - Sercomm
>          {USB_DEVICE(0x050D, 0x2103)},//Belkin - Edimax
>          {USB_DEVICE(0x20F4, 0x624D)},//TRENDnet
>          {USB_DEVICE(0x0DF6, 0x0061)},//Sitecom - Edimax
>          {USB_DEVICE(0x0B05, 0x17AB)},//ASUS - Edimax
> #endif
>          {}      /* Terminating entry */
> };
>
> While I can't confirm it myself, as I don't have any rtl8192cu hardware
> locally, I've gotten feedback[1] that temporarily adding new IDs via
>
> # modprobe rtl8192cu
> # echo -n "050d 2103">  /sys/bus/usb/drivers/rtl8192cu/new_id
>
> appears not be successful and might Oops the kernel[2]. Given that I
> can't test it myself and considering that the reporter's kernel is
> tainted, I can't claim this for sure - but I could ask the original
> reporter to test it again.
>
> Regards
> 	Stefan Lippers-Hollmann
>
> [1]	http://aptosid.com/index.php?name=PNphpBB2&file=viewtopic&t=1550&start=0
> [2]	http://pastebin.com/ppZJ0GmU

I have been holding a few new ID's that are in the vendor driver awaiting a 
test. These include the following:

+       {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)},
+       {RTL_USB_DEVICE(0x13d3, 0x3357, rtl92cu_hal_cfg)}, /* AzureWave */
+       {RTL_USB_DEVICE(0x13d3, 0x3358, rtl92cu_hal_cfg)}, /*Azwave 8188CE-VAU*/
-       {RTL_USB_DEVICE(0x3359, 0x13d3, rtl92cu_hal_cfg)},
+       {RTL_USB_DEVICE(0x13d3, 0x3359, rtl92cu_hal_cfg)},
+       {RTL_USB_DEVICE(0x4855, 0x0090, rtl92cu_hal_cfg)}, /* Feixun */
+       {RTL_USB_DEVICE(0x4855, 0x0091, rtl92cu_hal_cfg)}, /* NetweeN-Feixun */
+       {RTL_USB_DEVICE(0x9846, 0x9041, rtl92cu_hal_cfg)}, /* Netgear Cameo */
+       {RTL_USB_DEVICE(0x050d, 0x2102, rtl92cu_hal_cfg)}, /*Belkin-Sercomm*/
+       {RTL_USB_DEVICE(0x050d, 0x2103, rtl92cu_hal_cfg)}, /*Belkin-Edimax*/

The deleted entry has the vendor and product reversed. The first one in the list 
has been tested and works.

Based on your report, I will drop the 050d entries. If you get a confirmation 
that 050d,2103 works, then submit that patch.

Larry

