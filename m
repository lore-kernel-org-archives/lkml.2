Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab1KVFNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:13:22 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55286 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1KVFNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:13:21 -0500
Date: Tue, 22 Nov 2011 14:13:10 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111122051310.GA23705@gamma.logic.tuwien.ac.at>
References: <20111104045817.GA25778@gamma.logic.tuwien.ac.at> <20111107123812.GB23508@gamma.logic.tuwien.ac.at> <1320709047.31823.188.camel@wwguy-huron> <20111108043233.GA21171@gamma.logic.tuwien.ac.at> <CANUX_P0Q0wve4D6fZPsMv2Zw=02gb9u+3C2cjRv7UAmWqXnjzw@mail.gmail.com> <CANUX_P06ww42p6N1k_P-Y1KMKOd1QgR_DxVWe19qtsEX2rfWpw@mail.gmail.com> <20111109051152.GA16006@gamma.logic.tuwien.ac.at> <CANUX_P2Yz9bWP_EmU1Acs7Mu2w78CXxO-njhiMt97b0TJHFYiQ@mail.gmail.com> <20111121030640.GI32505@gamma.logic.tuwien.ac.at> <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P2AA5stHwjegKdFhFGg7jxwdVU2Xr8OUtXUdEOKz_6E5A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 21 Nov 2011, Emmanuel Grumbach wrote:
> > If you think I shouuld turn on power debug again and see hope that
> > it happens again, let me know.
> 
> No, I don't think it is needed. Thanks.

One more thing I realized now: While the connection is cut off
the kernel/network-manager belives I am connected:
# ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:16:ea:2c:6c:4a  
          inet addr:192.168.1.22  Bcast:192.168.1.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:20368 errors:0 dropped:0 overruns:0 frame:0
          TX packets:21606 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:11031455 (10.5 MiB)  TX bytes:2927239 (2.7 MiB)
#

If I do during this time a ping of a remote host, interestingly:
- TX packgets and TX bytes go UP
- RX bytes go also up!
- RX packages stay the same, seems that the RX packets are not recognized

It seems with the changes now the TX is working, but RX is not.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
RAMSGATE (n.)
All institutional buildings must, by law, contain at least twenty
ramsgates. These are doors which open the opposite way to the one you
expect.
			--- Douglas Adams, The Meaning of Liff
