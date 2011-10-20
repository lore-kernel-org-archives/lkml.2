Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1JTE7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 00:59:35 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:38868 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1JTE7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 00:59:34 -0400
Date: Thu, 20 Oct 2011 13:59:27 +0900
From: Norbert Preining <preining@logic.at>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111020045927.GB23044@gamma.logic.tuwien.ac.at>
References: <20111019064628.GA14817@gamma.logic.tuwien.ac.at> <1319004836.31823.57.camel@wwguy-huron> <20111019124931.GC3963@gamma.logic.tuwien.ac.at> <1319038282.25023.21.camel@wwguy-ubuntu> <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com> <20111019062517.GC11588@gamma.logic.tuwien.ac.at> <1319003304.31823.46.camel@wwguy-huron> <20111019064628.GA14817@gamma.logic.tuwien.ac.at> <1319004836.31823.57.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319038282.25023.21.camel@wwguy-ubuntu> <1319004836.31823.57.camel@wwguy-huron>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wey,

so I am now at the university, and it seems your last patch
did wonder. Here a log after waking up from suspend at university...

[17394.694774] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
[17394.892077] wlan0: associate with 00:24:c4:ab:bd:ef (try 2)
[17394.896190] wlan0: RX AssocResp from 00:24:c4:ab:bd:ef (capab=0x1 status=0 aid=2)
[17394.896199] wlan0: associated
[17394.974620] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (2)
[17394.976930] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (2)
[17409.608674] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
[17409.616748] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[17409.816093] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[17410.016083] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[17410.216086] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[17419.285141] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (0)
[17419.285315] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (0)
[17419.286583] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
[17419.300296] cfg80211: Calling CRDA for country: JP
[17419.309278] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
[17419.310105] wlan0: authenticated
[17419.317900] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
[17419.319837] wlan0: RX ReassocResp from 00:24:c4:ab:bd:ef (capab=0x1 status=0 aid=2)
[17419.319840] wlan0: associated
[17422.384922] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
[17509.576705] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[17509.776098] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[17509.976086] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[17509.980861] wlan0: direct probe responded
[17510.016116] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 1)
[17510.018753] wlan0: authenticated
[17510.042702] wlan0: associate with 00:24:c4:ab:bd:e0 (try 1)
[17510.050541] wlan0: RX ReassocResp from 00:24:c4:ab:bd:e0 (capab=0x421 status=0 aid=1)
[17510.050551] wlan0: associated
[17589.724188] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:e0 tid = 0
[17590.839852] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:e0 tid = 0

but the connection is up and working.

On Di, 18 Okt 2011, Guy, Wey-Yi wrote:
> Could you please let me know the brand/model of the AP which having
> problem. Also the configuration of your NIC also help.

THe AP is a big Cisco one, more I cannot see, with 3 antenna.

For the NIC, what do you want to know:
wlan0     IEEE 802.11abgn  ESSID:"XXXXXXXXXX"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:24:C4:AB:BD:E0   
          Bit Rate=72.2 Mb/s   Tx-Power=15 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=51/70  Signal level=-59 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:685  Invalid misc:59   Missed beacon:0

The last line looks interesting, excessive retires: 685, INvalid misc: 59


Note that the "Tx excessive retries" increase steaadily and radically,
downloading updates with aptitude I see afterwards:
	Tx excessive retries:17922

The "Invalid misc" also increase, but slowly.

On Mi, 19 Okt 2011, wwguy wrote:
> Are you connect on 5.2GHz? looks to me there were only one place can
> stop the queue which is for radar channel detection.

No, it is channel 1
$ iwlist wlan0 channel
wlan0     32 channels in total; available frequencies :
          Channel 01 : 2.412 GHz
          Channel 02 : 2.417 GHz
          Channel 03 : 2.422 GHz
          Channel 04 : 2.427 GHz
          Channel 05 : 2.432 GHz
          Channel 06 : 2.437 GHz
          Channel 07 : 2.442 GHz
          Channel 08 : 2.447 GHz
          Channel 09 : 2.452 GHz
          Channel 10 : 2.457 GHz
          Channel 11 : 2.462 GHz
          Channel 12 : 2.467 GHz
          Channel 13 : 2.472 GHz
          Channel 36 : 5.18 GHz
          Channel 40 : 5.2 GHz
          Channel 44 : 5.22 GHz
          Channel 48 : 5.24 GHz
          Channel 52 : 5.26 GHz
          Channel 56 : 5.28 GHz
          Channel 60 : 5.3 GHz
          Channel 64 : 5.32 GHz
          Channel 100 : 5.5 GHz
          Channel 104 : 5.52 GHz
          Channel 108 : 5.54 GHz
          Channel 112 : 5.56 GHz
          Channel 116 : 5.58 GHz
          Channel 120 : 5.6 GHz
          Channel 124 : 5.62 GHz
          Channel 128 : 5.64 GHz
          Channel 132 : 5.66 GHz
          Channel 136 : 5.68 GHz
          Channel 140 : 5.7 GHz
          Current Frequency:2.412 GHz (Channel 1)


Well, for the time being the patch is nice and helps, thanks!

If you want me to test more please let me know, but I am leaving
today for some business trip and will be back on Wednesday at 
work here.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
GOLANT (adj.)
Blank, sly and faintly embarrassed. Pertaining to the expression seen
on the face of someone who has clearly forgotten your name.
			--- Douglas Adams, The Meaning of Liff
