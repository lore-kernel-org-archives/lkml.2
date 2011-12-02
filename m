Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab1LBEsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 23:48:25 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:58958 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab1LBEsX (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 1 Dec 2011 23:48:23 -0500
MIME-Version: 1.0
In-Reply-To: <1321435176.15441.528.camel@aeonflux>
References: <2eb6d1b761a3fddea28294959bde7e9c7ef88043.1319086508.git.acho@suse.com>
	<20111031191809.GB10164@joana>
	<CAKzePaqwKbg8oZ6ULcdXdnYAkLU+k6o3bQWVaLUfCEDrH2994g@mail.gmail.com>
	<1321435176.15441.528.camel@aeonflux>
Date: Fri, 2 Dec 2011 12:48:07 +0800
Message-ID: <CAKzePapB0zAh6FtST1Bv8+Vz3+x8Pcro9dH2pCRQRGQr4=4z+Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] add device entry for Broadcom Valentine combo card
From: Al Cho <acho@suse.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        jlee@suse.com, oneukum@suse.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 5:19 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Al,
>
>> > * Cho, Yu-Chen <acho@suse.com> [2011-10-20 12:58:29 +0800]:
>> >
>> >> This device declares itself to be vendor specific
>> >> It therefore needs to be added to the device table
>> >> to make btusb bind.
>> >
>> > It would be good to have the output of usb-devices for this specific device in
>> > the commit message.
>>
>> Would you please kindly explain what is "the output of usb-device" to me?
>> The patch is for Broadcom Valentine 802.11bgn 1x1 wireless and
>> bluetooth combo card.
>
> open an xterm and type "usb-devices", then press return. And we want to
> see the part about this device.
>
> Regards
>
> Marcel
>
>
>

Hi All,

Really sorry for late to reply again.
List the information below:

T:  Bus=01 Lev=02 Prnt=02 Port=03 Cnt=01 Dev#=  3 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0a5c ProdID=21e3 Rev= 1.12
S:  Manufacturer=Broadcom Corp
S:  Product=BCM20702A0
S:  SerialNumber=889FFAABE086
C:* #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=84(I) Atr=02(Bulk) MxPS=  32 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=  32 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Sincerely,
             AL
