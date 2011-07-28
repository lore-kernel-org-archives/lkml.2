Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1G1QSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 12:18:36 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58936 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab1G1QSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 12:18:34 -0400
Message-ID: <4E318BD0.40202@lwfinger.net>
Date: Thu, 28 Jul 2011 11:18:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Ivo van Doorn <IvDoorn@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: 3.0: rt2800usb(Kernel PANIC) vs. rt2780sta(GOOD/2.6.38)
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 06:33 PM, Justin Piszcz wrote:
> Hi,
>
> Kernel 3.0 (rt2800usb driver- horrid, and then it panics moments after, see
> picture below)
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=301 ttl=64 time=146 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=302 ttl=64 time=274 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=303 ttl=64 time=197 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=304 ttl=64 time=115 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=305 ttl=64 time=243 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=306 ttl=64 time=265 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=307 ttl=64 time=183 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=308 ttl=64 time=201 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=309 ttl=64 time=236 ms
>
> Then it crashes if you use the network:
> http://home.comcast.net/~jpiszcz/20110727/photo.JPG
>
> With the rt2870sta driver, the machine has been solid for months (2.6.38) with
> consistent low pings:
>
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=2 ttl=64 time=1.38 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=3 ttl=64 time=0.520 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=4 ttl=64 time=1.11 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=5 ttl=64 time=0.573 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=6 ttl=64 time=0.562 ms
>
> Can we please get the rt2870sta back into the kernel?

No. One of the reasons for deleting rt2870sta was that having it around was 
preventing the use of rt2800usb and it was not getting debugged.

This problem does not happen on my device.

Bus 001 Device 004: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless 
Adapter

That device is an unbranded USB stick that I got from Ebay for $2.59. My pings are

PING sonylap (192.168.1.50) 56(84) bytes of data.
64 bytes from sonylap (192.168.1.50): icmp_req=1 ttl=64 time=13.2 ms
64 bytes from sonylap (192.168.1.50): icmp_req=2 ttl=64 time=11.3 ms
64 bytes from sonylap (192.168.1.50): icmp_req=3 ttl=64 time=10.3 ms
64 bytes from sonylap (192.168.1.50): icmp_req=4 ttl=64 time=10.5 ms
64 bytes from sonylap (192.168.1.50): icmp_req=5 ttl=64 time=11.6 ms
64 bytes from sonylap (192.168.1.50): icmp_req=6 ttl=64 time=11.2 ms
64 bytes from sonylap (192.168.1.50): icmp_req=7 ttl=64 time=10.1 ms
64 bytes from sonylap (192.168.1.50): icmp_req=8 ttl=64 time=11.7 ms
64 bytes from sonylap (192.168.1.50): icmp_req=9 ttl=64 time=10.7 ms
64 bytes from sonylap (192.168.1.50): icmp_req=10 ttl=64 time=13.2 ms
64 bytes from sonylap (192.168.1.50): icmp_req=11 ttl=64 time=10.2 ms
64 bytes from sonylap (192.168.1.50): icmp_req=12 ttl=64 time=11.6 ms
64 bytes from sonylap (192.168.1.50): icmp_req=13 ttl=64 time=10.7 ms
64 bytes from sonylap (192.168.1.50): icmp_req=14 ttl=64 time=10.6 ms
64 bytes from sonylap (192.168.1.50): icmp_req=15 ttl=64 time=16.0 ms
64 bytes from sonylap (192.168.1.50): icmp_req=16 ttl=64 time=10.3 ms
^C
--- sonylap ping statistics ---
16 packets transmitted, 16 received, 0% packet loss, time 15025ms
rtt min/avg/max/mdev = 10.194/11.499/16.075/1.502 ms

Performance is adequate, but not sparkling. Using tcpperf, I get 6 Mbps upload 
speed on an 802.11n network. The output of iwconfig says that I have a speed of 
121.5 Mbps set, but I'm only getting 1/10th of the transmit rate that I would 
expect for that setting.

@Ivo: I don't know if you saw this or not. From the photo, the kernel panics on 
a page fault in interrupt mode. The traceback is to rt2800usb_write_tx_desc+0x4, 
which seems to implicate the inline routine get_skb_frame_desc(). The offending 
statement is

return (struct skb_frame_desc *)&IEEE80211_SKB_CB(skb)->driver_data;

Any thoughts on how either the skb or the driver_data member might not be setup 
correctly?

Thanks,

Larry
