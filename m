Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab1EZQYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:24:09 -0400
Received: from lucidpixels.com ([75.144.35.66]:45788 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab1EZQYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:24:07 -0400
Date: Thu, 26 May 2011 12:24:06 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jools Wills <buzz@exotica.org.uk>
cc: Walter Goldens <goldenstranger@yahoo.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
In-Reply-To: <4DBFFE64.6000306@exotica.org.uk>
Message-ID: <alpine.DEB.2.02.1105261221240.8379@p34.internal.lan>
References: <484421.61252.qm@web161619.mail.bf1.yahoo.com> <4DBFFE64.6000306@exotica.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 May 2011, Jools Wills wrote:

> in case it is useful:
>
> I am currently using the vendor driver on a device I have (O2 Joggler).
> The rt2800usb driver didn't work well and the staging rt2870sta driver
> didn't seem to work with wireless N and users reported to me that it
> drops the connection and is unreliable. The vendor driver does seem to
> work best.
>
> I made a debian package (using dkms) of the vendor driver on my joggler
> ppa. tested working wiht 2.6.37/2.6.38
>
> https://launchpad.net/~jools/+archive/joggler
>
> note it doesn't automatically install the newer firmware so that will
> need to be done manually.
>
> Best Regards
>
> Jools
>

Hi,

Tried 2.6.39, laggy, lots of errors, going to go back to 2.6.38 w/ rt2870sta.

[ 9514.700343] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9524.700306] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9526.700279] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9538.700270] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9539.700227] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9577.700342] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9579.700314] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9585.700238] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9595.700352] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9598.700314] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9598.869690] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 46
[ 9598.873113] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 47
[ 9598.877453] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 48
[ 9598.884587] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 49
[ 9598.889435] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 50
[ 9598.896697] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 51
[ 9598.901949] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 52
[ 9598.908197] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 53
[ 9598.911798] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 54
[ 9598.931461] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 55
[ 9599.700317] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9600.700287] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[ 9601.760057] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 62
[ 9601.764633] phy0 -> rt2800_txdone_entry_check: Warning - TX status report missed for queue 2 entry 63

$ ping atomw
PING atomw.internal.lan (1.1.1.1) 56(84) bytes of data.
64 bytes from atomw.internal.lan (1.1.1.1): icmp_req=3 ttl=64 time=1540 ms
64 bytes from atomw.internal.lan (1.1.1.1): icmp_req=4 ttl=64 time=639 ms
64 bytes from atomw.internal.lan (1.1.1.1): icmp_req=5 ttl=64 time=571 ms
64 bytes from atomw.internal.lan (1.1.1.1): icmp_req=6 ttl=64 time=492 ms
64 bytes from atomw.internal.lan (1.1.1.1): icmp_req=7 ttl=64 time=510 ms
64 bytes from atomw.internal.lan (1.1.1.1): icmp_req=8 ttl=64 time=528 ms
64 bytes from atomw.internal.lan (1.1.1.1): icmp_req=9 ttl=64 time=538 ms
^C
--- atomw.internal.lan ping statistics ---
9 packets transmitted, 7 received, 22% packet loss, time 8004ms
rtt min/avg/max/mdev = 492.253/688.793/1540.319/350.472 ms, pipe 2

Is there a certain or driver one should use with a MediaLink USB adapter?
http://www.amazon.com/Medialink-Wireless-Adapter-802-11n-Compatible/dp/B002RM08RE

The rt2870sta works flawlessly with 2.6.38.
The rt2800usb is very problamtic.

Thanks,

Justin.

