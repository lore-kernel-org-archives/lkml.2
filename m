Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1FMTLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:11:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42184 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1FMTLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:11:16 -0400
MIME-Version: 1.0
In-Reply-To: <4DF65472.9070601@candelatech.com>
References: <BLU158-w3633DDF37956A9F5672C1F87690@phx.gbl> <BLU158-w58841DE4774E18813C30CA87690@phx.gbl>
 <4DF65472.9070601@candelatech.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 13 Jun 2011 12:10:54 -0700
Message-ID: <BANLkTimQXUGwfyX79cny2Oi_bH6HPi=kTw@mail.gmail.com>
Subject: Re: [ath9k-devel] AR9380 current driver supported features
To: Ben Greear <greearb@candelatech.com>
Cc: Fred Matthews <fredmm@hotmail.co.uk>, ionic@ionic.de,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I cut out the stuff about channels, as that seems to be highly
dependent on which source you get your NIC from and what country code
is programmed in.

This is using kernel 3.0-rc2 and the very latest (I just pulled)
iw.git. The NIC is not associated, all I did was modprobe ath9k.

Dan

% iw list
Wiphy phy0
	Band 1:
		Capabilities: 0x11ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-23
		Bitrates (non-HT):
			* 1.0 Mbps
			* 2.0 Mbps (short preamble supported)
			* 5.5 Mbps (short preamble supported)
			* 11.0 Mbps (short preamble supported)
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	Band 2:
		Capabilities: 0x11ef
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-23
		Bitrates (non-HT):
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	max # scan SSIDs: 4
	max scan IEs length: 2257 bytes
	Coverage class: 0 (up to 0m)
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * WDS
		 * monitor
		 * P2P-client
		 * P2P-GO
	software interface modes (can always be added):
		 * AP/VLAN
		 * monitor
	valid interface combinations:
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * new_beacon
		 * new_station
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * remain_on_channel
		 * set_tx_bitrate_mask
		 * action
		 * frame_wait_cancel
		 * set_wiphy_netns
		 * set_channel
		 * set_wds_peer
		 * connect
		 * disconnect
	Supported TX frame types:
		 * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060
0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060
0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
		 * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070
0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
	Supported RX frame types:
		 * IBSS: 0x00d0
		 * managed: 0x0040 0x00d0
		 * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
		 * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
		 * mesh point: 0x00b0 0x00c0 0x00d0
		 * P2P-client: 0x0040 0x00d0
		 * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
	Device supports RSN-IBSS.


On Mon, Jun 13, 2011 at 11:18 AM, Ben Greear <greearb@candelatech.com> wrote:
>
> On 06/13/2011 11:09 AM, Fred Matthews wrote:
>>
>> Hi,I am looking to upgrade my current nodes and AP from the AR9280 2x2 MIMO NIC to the AR9380 3x3 NIC.
>> Thus I was wondering if someone can kindly comment on the current chipset stability with ath9k, also the current supported features (e.g.  "iw list" output) such as setting the NIC as an AP/Master using hostapd, Greenfield mode, TxBF, CSI info, and LPDC as well as rates achieved.
>> Thanks in advance
>
> Both are stable in our testing (virtual stations, AP mode), but we're having
> a hard time sourcing AR9380 3x3 NICs..getting ship-times in August, etc....
>
> I don't have details on the other things you ask about.
>
> I'd suggest getting a few NICs and trying them out in your environment.
> Even if they have problems, there are folks actively working on it and
> likely it can be fixed.  And at least for our use with virtual stations & APs,
> there is no other NIC that comes close to the features that Atheros offers.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
