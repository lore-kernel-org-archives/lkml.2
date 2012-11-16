Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2KPVt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:49:27 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60844 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752989Ab2KPVt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:49:26 -0500
Message-ID: <50A6B4B9.4060804@xenotime.net>
Date: Fri, 16 Nov 2012 13:48:41 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LAPIS SEMICONDUCTOR <tshimizu818@gmail.com>
Subject: Re: linux-next: Tree for Nov 15 (pch_gbe)
References: <20121115181740.4fb08780f0b92149a5ed2ca4@canb.auug.org.au>
In-Reply-To: <20121115181740.4fb08780f0b92149a5ed2ca4@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 11:17 PM, Stephen Rothwell wrote:

> Hi all,
> 
> News: this one will be the last release until next-20121126 (which should
> be just be after -rc7, I guess - assuming that Linus does not release
> v3.7 before then).
> 
> Changes since 20121114:
> 


on x86_64:

drivers/built-in.o: In function `pch_tx_timestamp':
pch_gbe_main.c:(.text+0x5b9b08): undefined reference to `pch_ch_event_read'
pch_gbe_main.c:(.text+0x5b9b39): undefined reference to `pch_tx_snap_read'
pch_gbe_main.c:(.text+0x5b9b6c): undefined reference to `pch_ch_event_write'
drivers/built-in.o: In function `pch_rx_timestamp':
pch_gbe_main.c:(.text+0x5ba648): undefined reference to `pch_ch_event_read'
pch_gbe_main.c:(.text+0x5ba658): undefined reference to `pch_src_uuid_lo_read'
pch_gbe_main.c:(.text+0x5ba663): undefined reference to `pch_src_uuid_hi_read'
pch_gbe_main.c:(.text+0x5ba709): undefined reference to `pch_ch_event_write'
pch_gbe_main.c:(.text+0x5ba717): undefined reference to `pch_rx_snap_read'
drivers/built-in.o: In function `hwtstamp_ioctl.clone.13':
pch_gbe_main.c:(.text+0x5bb3b0): undefined reference to `pch_ch_control_write'
pch_gbe_main.c:(.text+0x5bb3c9): undefined reference to `pch_ch_control_write'
pch_gbe_main.c:(.text+0x5bb3e2): undefined reference to `pch_ch_control_write'
pch_gbe_main.c:(.text+0x5bb406): undefined reference to `pch_ch_control_write'
pch_gbe_main.c:(.text+0x5bb426): undefined reference to `pch_set_station_address'
pch_gbe_main.c:(.text+0x5bb433): undefined reference to `pch_ch_event_write'

when PTP_1588_CLOCK_PCH is not enabled.

Want to select PTP_1588_CLOCK_PCH for PCH_GBE?

-- 
~Randy
