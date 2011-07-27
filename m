Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1G0XdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 19:33:07 -0400
Received: from lucidpixels.com ([72.73.18.11]:58674 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab1G0XdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 19:33:06 -0400
Date: Wed, 27 Jul 2011 19:33:05 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: 3.0: rt2800usb(Kernel PANIC) vs. rt2780sta(GOOD/2.6.38)
Message-ID: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel 3.0 (rt2800usb driver- horrid, and then it panics moments after, 
see picture below)
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=301 ttl=64 time=146 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=302 ttl=64 time=274 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=303 ttl=64 time=197 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=304 ttl=64 time=115 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=305 ttl=64 time=243 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=306 ttl=64 time=265 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=307 ttl=64 time=183 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=308 ttl=64 time=201 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=309 ttl=64 time=236 ms

Then it crashes if you use the network:
http://home.comcast.net/~jpiszcz/20110727/photo.JPG

With the rt2870sta driver, the machine has been solid for months (2.6.38) 
with consistent low pings:

64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=2 ttl=64 time=1.38 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=3 ttl=64 time=0.520 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=4 ttl=64 time=1.11 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=5 ttl=64 time=0.573 ms
64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=6 ttl=64 time=0.562 ms

Can we please get the rt2870sta back into the kernel?

If not, can someone recommend a USB wireless stick that works in Linux 
that is not based on RALINK that does not crash the kernel and gets as 
good as pings as the one I have (most highest rated on Amazon that 
everyone seems to buy) with the rt2870sta driver?
http://www.amazon.com/Medialink-Wireless-Adapter-802-11n-Compatible/dp/B002RM08RE


Justin.
