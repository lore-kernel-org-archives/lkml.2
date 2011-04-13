Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1DMQBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:01:37 -0400
Received: from lucidpixels.com ([75.144.35.66]:49685 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab1DMQBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:01:34 -0400
Date: Wed, 13 Apr 2011 12:01:33 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
In-Reply-To: <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1104131200220.2954@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-245785011-1302710493=:2954"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-245785011-1302710493=:2954
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 13 Apr 2011, Ivo Van Doorn wrote:

> Hi,
>
>> I recall using this driver in staging and it crashing my machine, now th=
ats
>> its no longer in staging, I thought I'd give it another try.. =A0Using t=
he
>
> The rt2800usb was not in staging but has been inside the main kernel
> tree for quite
> some time already, the alternative rt2870sta was in staging and will
> be removed very soon.
>
>> following wireless usb adapter, I'm seeing very high latency when using
>> the device in Linux, (with Windows, there are no problems). =A0Using Deb=
ian
>> Testing + wpa_supplicant, using the following USB adapter:
>
> Can you try disabling powersaving?
> iwconfig wlan0 power off
>
> Ivo
>

Hi,

Wow! That was it, now its interactive again.

64 bytes from wireless-host (192.168.1.2): icmp_req=3D1 ttl=3D64 time=3D0.5=
81 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=3D2 ttl=3D64 time=3D0.6=
47 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=3D3 ttl=3D64 time=3D0.5=
69 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=3D4 ttl=3D64 time=3D0.6=
86 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=3D5 ttl=3D64 time=3D0.6=
74 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=3D6 ttl=3D64 time=3D1.1=
8 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=3D7 ttl=3D64 time=3D1.7=
7 ms
64 bytes from wireless-host (192.168.1.2): icmp_req=3D8 ttl=3D64 time=3D0.6=
54 ms

Thanks, so its recommend to keep this off then, can that be set as the=20
driver default?

Justin.


--655872-245785011-1302710493=:2954--
