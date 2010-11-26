Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab0KZL1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:27:43 -0500
Received: from mail.sysgo.com ([195.145.229.155]:38788 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab0KZL1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:27:41 -0500
Date: Fri, 26 Nov 2010 12:27:37 +0100
From: Pavel Machek <pma@sysgo.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, ath9k-devel@venema.h4ckr.net,
        Sujith.Manoharan@atheros.com
Cc: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, rudolf.marek@sysgo.com, cko@sysgo.com,
        mfa@sysgo.com, anl@sysgo.com
Subject: Re: ath9k_htc vs. powerpc (was Re: working usb wifi card, that is
 still possible to buy)
Message-ID: <20101126112737.GB11857@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
 <20101124081616.GA30595@pma.sysgo.com>
 <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
 <20101126083125.GA28982@pma.sysgo.com>
 <20101126102026.GA11857@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126102026.GA11857@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Sujith, I see you fought with endianness issues on ath9k_htc
driver. Was you able to test it on actual hardware? Should I try the
version just after your commit?

								Pavel

> Editing ath_print() works. Question is what is relevant debug info for this...? 
> 
> > Diffences to the mpc5200b board are:
> > 
> > a) it is PowerPC, thus big-endian board
> > 
> > b) it only has USB1.1 controller.
> 
> I tried on PC with USB2 disabled (EHCI not configured in) and it still
> worked ok.
> 
> 								Pavel
> 
> # iwconfig wlan0 essid SYSGO
> ath: FULL-SLEEP -> AWAKE
> ath: AWAKE -> FULL-SLEEP
> ath: not-idle: enabling radio
> ath: FULL-SLEEP -> AWAKE
> ath: PDADC (0,   0): a280 05040302
> ath: PDADC: Chain 0 | PDADC   0 Value   2 | PDADC   1 Value   3 | PDADC   2 Value   4 | PDADC   3 Value   5 |
> ath: PDADC (0,   0): a284 09080706
> ath: PDADC: Chain 0 | PDADC   4 Value   6 | PDADC   5 Value   7 | PDADC   6 Value   8 | PDADC   7 Value   9 |
> ath: PDADC (0,   0): a288 0e0c0b0a
> ath: PDADC: Chain 0 | PDADC   8 Value  10 | PDADC   9 Value  11 | PDADC  10 Value  12 | PDADC  11 Value  14 |
> ath: PDADC (0,   0): a28c 1211100f
> ath: PDADC: Chain 0 | PDADC  12 Value  15 | PDADC  13 Value  16 | PDADC  14 Value  17 | PDADC  15 Value  18 |
> ath: PDADC (0,   0): a290 18161514
> ath: PDADC: Chain 0 | PDADC  16 Value  20 | PDADC  17 Value  21 | PDADC  18 Value  22 | PDADC  19 Value  24 |
> ath: PDADC (0,   0): a294 211d1b19
> ath: PDADC: Chain 0 | PDADC  20 Value  25 | PDADC  21 Value  27 | PDADC  22 Value  29 | PDADC  23 Value  33 |
> ath: PDADC (0,   0): a298 2f2c2824
> ath: PDADC: Chain 0 | PDADC  24 Value  36 | PDADC  25 Value  40 | PDADC  26 Value  44 | PDADC  27 Value  47 |
> ath: PDADC (0,   0): a29c 3f3a3633
> ath: PDADC: Chain 0 | PDADC  28 Value  51 | PDADC  29 Value  54 | PDADC  30 Value  58 | PDADC  31 Value  63 |
> ath: PDADC (0,   0): a2a0 5a534d46
> ath: PDADC: Chain 0 | PDADC  32 Value  70 | PDADC  33 Value  77 | PDADC  34 Value  83 | PDADC  35 Value  90 |
> ath: PDADC (0,   0): a2a4 766f6861
> ath: PDADC: Chain 0 | PDADC  36 Value  97 | PDADC  37 Value 104 | PDADC  38 Value 111 | PDADC  39 Value 118 |
> ath: PDADC (0,   0): a2a8 928b847d
> ath: PDADC: Chain 0 | PDADC  40 Value 125 | PDADC  41 Value 132 | PDADC  42 Value 139 | PDADC  43 Value 146 |
> ath: PDADC (0,   0): a2ac 302d2a99
> ath: PDADC: Chain 0 | PDADC  44 Value 153 | PDADC  45 Value  42 | PDADC  46 Value  45 | PDADC  47 Value  48 |
> ath: PDADC (0,   0): a2b0 3d393633
> ath: PDADC: Chain 0 | PDADC  48 Value  51 | PDADC  49 Value  54 | PDADC  50 Value  57 | PDADC  51 Value  61 |
> ath: PDADC (0,   0): a2b4 4e484440
> ath: PDADC: Chain 0 | PDADC  52 Value  64 | PDADC  53 Value  68 | PDADC  54 Value  72 | PDADC  55 Value  78 |
> ath: PDADC (0,   0): a2b8 66605a54
> ath: PDADC: Chain 0 | PDADC  56 Value  84 | PDADC  57 Value  90 | PDADC  58 Value  96 | PDADC  59 Value 102 |
> ath: PDADC (0,   0): a2bc 887f776e
> ath: PDADC: Chain 0 | PDADC  60 Value 110 | PDADC  61 Value 119 | PDADC  62 Value 127 | PDADC  63 Value 136 |
> ath: PDADC (0,   0): a2c0 a8a19991
> ath: PDADC: Chain 0 | PDADC  64 Value 145 | PDADC  65 Value 153 | PDADC  66 Value 161 | PDADC  67 Value 168 |
> ath: PDADC (0,   0): a2c4 c4bdb6af
> ath: PDADC: Chain 0 | PDADC  68 Value 175 | PDADC  69 Value 182 | PDADC  70 Value 189 | PDADC  71 Value 196 |
> ath: PDADC (0,   0): a2c8 d9d9d2cb
> ath: PDADC: Chain 0 | PDADC  72 Value 203 | PDADC  73 Value 210 | PDADC  74 Value 217 | PDADC  75 Value 217 |
> ath: PDADC (0,   0): a2cc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  76 Value 217 | PDADC  77 Value 217 | PDADC  78 Value 217 | PDADC  79 Value 217 |
> ath: PDADC (0,   0): a2d0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  80 Value 217 | PDADC  81 Value 217 | PDADC  82 Value 217 | PDADC  83 Value 217 |
> ath: PDADC (0,   0): a2d4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  84 Value 217 | PDADC  85 Value 217 | PDADC  86 Value 217 | PDADC  87 Value 217 |
> ath: PDADC (0,   0): a2d8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  88 Value 217 | PDADC  89 Value 217 | PDADC  90 Value 217 | PDADC  91 Value 217 |
> ath: PDADC (0,   0): a2dc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  92 Value 217 | PDADC  93 Value 217 | PDADC  94 Value 217 | PDADC  95 Value 217 |
> ath: PDADC (0,   0): a2e0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  96 Value 217 | PDADC  97 Value 217 | PDADC  98 Value 217 | PDADC  99 Value 217 |
> ath: PDADC (0,   0): a2e4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 100 Value 217 | PDADC 101 Value 217 | PDADC 102 Value 217 | PDADC 103 Value 217 |
> ath: PDADC (0,   0): a2e8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 104 Value 217 | PDADC 105 Value 217 | PDADC 106 Value 217 | PDADC 107 Value 217 |
> ath: PDADC (0,   0): a2ec d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 108 Value 217 | PDADC 109 Value 217 | PDADC 110 Value 217 | PDADC 111 Value 217 |
> ath: PDADC (0,   0): a2f0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 112 Value 217 | PDADC 113 Value 217 | PDADC 114 Value 217 | PDADC 115 Value 217 |
> ath: PDADC (0,   0): a2f4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 116 Value 217 | PDADC 117 Value 217 | PDADC 118 Value 217 | PDADC 119 Value 217 |
> ath: PDADC (0,   0): a2f8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 120 Value 217 | PDADC 121 Value 217 | PDADC 122 Value 217 | PDADC 123 Value 217 |
> ath: PDADC (0,   0): a2fc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 124 Value 217 | PDADC 125 Value 217 | PDADC 126 Value 217 | PDADC 127 Value 217 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Reset TX queue: 0
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 1
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 2
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 3
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TXQ, inactive queue: 4
> ath: Reset TXQ, inactive queue: 5
> ath: Reset TXQ, inactive queue: 6
> ath: Reset TXQ, inactive queue: 7
> ath: Reset TX queue: 8
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 9
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: ah->misc_mode 0x4
> ath: enabling ADC Gain Calibration.
> ath: enabling ADC DC Calibration.
> ath: enabling IQ Calibration.
> ath: starting ADC Gain Calibration
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set HW RX filter: 0x17
> -/bin/sh-3.00# ath: Set channel: 2412 MHz
> ath: (2412 MHz) -> (2412 MHz), HT: 0, HT40: 0 fastcc: 0
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 05040302
> ath: PDADC: Chain 0 | PDADC   0 Value   2 | PDADC   1 Value   3 | PDADC   2 Value   4 | PDADC   3 Value   5 |
> ath: PDADC (0,   0): a284 09080706
> ath: PDADC: Chain 0 | PDADC   4 Value   6 | PDADC   5 Value   7 | PDADC   6 Value   8 | PDADC   7 Value   9 |
> ath: PDADC (0,   0): a288 0e0c0b0a
> ath: PDADC: Chain 0 | PDADC   8 Value  10 | PDADC   9 Value  11 | PDADC  10 Value  12 | PDADC  11 Value  14 |
> ath: PDADC (0,   0): a28c 1211100f
> ath: PDADC: Chain 0 | PDADC  12 Value  15 | PDADC  13 Value  16 | PDADC  14 Value  17 | PDADC  15 Value  18 |
> ath: PDADC (0,   0): a290 18161514
> ath: PDADC: Chain 0 | PDADC  16 Value  20 | PDADC  17 Value  21 | PDADC  18 Value  22 | PDADC  19 Value  24 |
> ath: PDADC (0,   0): a294 211d1b19
> ath: PDADC: Chain 0 | PDADC  20 Value  25 | PDADC  21 Value  27 | PDADC  22 Value  29 | PDADC  23 Value  33 |
> ath: PDADC (0,   0): a298 2f2c2824
> ath: PDADC: Chain 0 | PDADC  24 Value  36 | PDADC  25 Value  40 | PDADC  26 Value  44 | PDADC  27 Value  47 |
> ath: PDADC (0,   0): a29c 3f3a3633
> ath: PDADC: Chain 0 | PDADC  28 Value  51 | PDADC  29 Value  54 | PDADC  30 Value  58 | PDADC  31 Value  63 |
> ath: PDADC (0,   0): a2a0 5a534d46
> ath: PDADC: Chain 0 | PDADC  32 Value  70 | PDADC  33 Value  77 | PDADC  34 Value  83 | PDADC  35 Value  90 |
> ath: PDADC (0,   0): a2a4 766f6861
> ath: PDADC: Chain 0 | PDADC  36 Value  97 | PDADC  37 Value 104 | PDADC  38 Value 111 | PDADC  39 Value 118 |
> ath: PDADC (0,   0): a2a8 928b847d
> ath: PDADC: Chain 0 | PDADC  40 Value 125 | PDADC  41 Value 132 | PDADC  42 Value 139 | PDADC  43 Value 146 |
> ath: PDADC (0,   0): a2ac 302d2a99
> ath: PDADC: Chain 0 | PDADC  44 Value 153 | PDADC  45 Value  42 | PDADC  46 Value  45 | PDADC  47 Value  48 |
> ath: PDADC (0,   0): a2b0 3d393633
> ath: PDADC: Chain 0 | PDADC  48 Value  51 | PDADC  49 Value  54 | PDADC  50 Value  57 | PDADC  51 Value  61 |
> ath: PDADC (0,   0): a2b4 4e484440
> ath: PDADC: Chain 0 | PDADC  52 Value  64 | PDADC  53 Value  68 | PDADC  54 Value  72 | PDADC  55 Value  78 |
> ath: PDADC (0,   0): a2b8 66605a54
> ath: PDADC: Chain 0 | PDADC  56 Value  84 | PDADC  57 Value  90 | PDADC  58 Value  96 | PDADC  59 Value 102 |
> ath: PDADC (0,   0): a2bc 887f776e
> ath: PDADC: Chain 0 | PDADC  60 Value 110 | PDADC  61 Value 119 | PDADC  62 Value 127 | PDADC  63 Value 136 |
> ath: PDADC (0,   0): a2c0 a8a19991
> ath: PDADC: Chain 0 | PDADC  64 Value 145 | PDADC  65 Value 153 | PDADC  66 Value 161 | PDADC  67 Value 168 |
> ath: PDADC (0,   0): a2c4 c4bdb6af
> ath: PDADC: Chain 0 | PDADC  68 Value 175 | PDADC  69 Value 182 | PDADC  70 Value 189 | PDADC  71 Value 196 |
> ath: PDADC (0,   0): a2c8 d9d9d2cb
> ath: PDADC: Chain 0 | PDADC  72 Value 203 | PDADC  73 Value 210 | PDADC  74 Value 217 | PDADC  75 Value 217 |
> ath: PDADC (0,   0): a2cc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  76 Value 217 | PDADC  77 Value 217 | PDADC  78 Value 217 | PDADC  79 Value 217 |
> ath: PDADC (0,   0): a2d0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  80 Value 217 | PDADC  81 Value 217 | PDADC  82 Value 217 | PDADC  83 Value 217 |
> ath: PDADC (0,   0): a2d4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  84 Value 217 | PDADC  85 Value 217 | PDADC  86 Value 217 | PDADC  87 Value 217 |
> ath: PDADC (0,   0): a2d8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  88 Value 217 | PDADC  89 Value 217 | PDADC  90 Value 217 | PDADC  91 Value 217 |
> ath: PDADC (0,   0): a2dc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  92 Value 217 | PDADC  93 Value 217 | PDADC  94 Value 217 | PDADC  95 Value 217 |
> ath: PDADC (0,   0): a2e0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  96 Value 217 | PDADC  97 Value 217 | PDADC  98 Value 217 | PDADC  99 Value 217 |
> ath: PDADC (0,   0): a2e4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 100 Value 217 | PDADC 101 Value 217 | PDADC 102 Value 217 | PDADC 103 Value 217 |
> ath: PDADC (0,   0): a2e8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 104 Value 217 | PDADC 105 Value 217 | PDADC 106 Value 217 | PDADC 107 Value 217 |
> ath: PDADC (0,   0): a2ec d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 108 Value 217 | PDADC 109 Value 217 | PDADC 110 Value 217 | PDADC 111 Value 217 |
> ath: PDADC (0,   0): a2f0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 112 Value 217 | PDADC 113 Value 217 | PDADC 114 Value 217 | PDADC 115 Value 217 |
> ath: PDADC (0,   0): a2f4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 116 Value 217 | PDADC 117 Value 217 | PDADC 118 Value 217 | PDADC 119 Value 217 |
> ath: PDADC (0,   0): a2f8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 120 Value 217 | PDADC 121 Value 217 | PDADC 122 Value 217 | PDADC 123 Value 217 |
> ath: PDADC (0,   0): a2fc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 124 Value 217 | PDADC 125 Value 217 | PDADC 126 Value 217 | PDADC 127 Value 217 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Reset TX queue: 0
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 1
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 2
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 3
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TXQ, inactive queue: 4
> ath: Reset TXQ, inactive queue: 5
> ath: Reset TXQ, inactive queue: 6
> ath: Reset TXQ, inactive queue: 7
> ath: Reset TX queue: 8
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 9
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: ah->misc_mode 0x4
> ath: enabling ADC Gain Calibration.
> ath: enabling ADC DC Calibration.
> ath: enabling IQ Calibration.
> ath: starting ADC Gain Calibration
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2417 MHz
> ath: (2412 MHz) -> (2417 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 04030201
> ath: PDADC: Chain 0 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
> ath: PDADC (0,   0): a284 08070605
> ath: PDADC: Chain 0 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   7 | PDADC   7 Value   8 |
> ath: PDADC (0,   0): a288 0d0b0a09
> ath: PDADC: Chain 0 | PDADC   8 Value   9 | PDADC   9 Value  10 | PDADC  10 Value  11 | PDADC  11 Value  13 |
> ath: PDADC (0,   0): a28c 100f0e0e
> ath: PDADC: Chain 0 | PDADC  12 Value  14 | PDADC  13 Value  14 | PDADC  14 Value  15 | PDADC  15 Value  16 |
> ath: PDADC (0,   0): a290 16141312
> ath: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  19 | PDADC  18 Value  20 | PDADC  19 Value  22 |
> ath: PDADC (0,   0): a294 201c1a18
> ath: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  28 | PDADC  23 Value  32 |
> ath: PDADC (0,   0): a298 2e2b2723
> ath: PDADC: Chain 0 | PDADC  24 Value  35 | PDADC  25 Value  39 | PDADC  26 Value  43 | PDADC  27 Value  46 |
> ath: PDADC (0,   0): a29c 3e393532
> ath: PDADC: Chain 0 | PDADC  28 Value  50 | PDADC  29 Value  53 | PDADC  30 Value  57 | PDADC  31 Value  62 |
> ath: PDADC (0,   0): a2a0 59524c45
> ath: PDADC: Chain 0 | PDADC  32 Value  69 | PDADC  33 Value  76 | PDADC  34 Value  82 | PDADC  35 Value  89 |
> ath: PDADC (0,   0): a2a4 756e6760
> ath: PDADC: Chain 0 | PDADC  36 Value  96 | PDADC  37 Value 103 | PDADC  38 Value 110 | PDADC  39 Value 117 |
> ath: PDADC (0,   0): a2a8 918a837c
> ath: PDADC: Chain 0 | PDADC  40 Value 124 | PDADC  41 Value 131 | PDADC  42 Value 138 | PDADC  43 Value 145 |
> ath: PDADC (0,   0): a2ac 2c282498
> ath: PDADC: Chain 0 | PDADC  44 Value 152 | PDADC  45 Value  36 | PDADC  46 Value  40 | PDADC  47 Value  44 |
> ath: PDADC (0,   0): a2b0 3c383430
> ath: PDADC: Chain 0 | PDADC  48 Value  48 | PDADC  49 Value  52 | PDADC  50 Value  56 | PDADC  51 Value  60 |
> ath: PDADC (0,   0): a2b4 4d47433f
> ath: PDADC: Chain 0 | PDADC  52 Value  63 | PDADC  53 Value  67 | PDADC  54 Value  71 | PDADC  55 Value  77 |
> ath: PDADC (0,   0): a2b8 655f5953
> ath: PDADC: Chain 0 | PDADC  56 Value  83 | PDADC  57 Value  89 | PDADC  58 Value  95 | PDADC  59 Value 101 |
> ath: PDADC (0,   0): a2bc 867e766d
> ath: PDADC: Chain 0 | PDADC  60 Value 109 | PDADC  61 Value 118 | PDADC  62 Value 126 | PDADC  63 Value 134 |
> ath: PDADC (0,   0): a2c0 a8a0978f
> ath: PDADC: Chain 0 | PDADC  64 Value 143 | PDADC  65 Value 151 | PDADC  66 Value 160 | PDADC  67 Value 168 |
> ath: PDADC (0,   0): a2c4 c4bdb6af
> ath: PDADC: Chain 0 | PDADC  68 Value 175 | PDADC  69 Value 182 | PDADC  70 Value 189 | PDADC  71 Value 196 |
> ath: PDADC (0,   0): a2c8 d9d9d2cb
> ath: PDADC: Chain 0 | PDADC  72 Value 203 | PDADC  73 Value 210 | PDADC  74 Value 217 | PDADC  75 Value 217 |
> ath: PDADC (0,   0): a2cc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  76 Value 217 | PDADC  77 Value 217 | PDADC  78 Value 217 | PDADC  79 Value 217 |
> ath: PDADC (0,   0): a2d0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  80 Value 217 | PDADC  81 Value 217 | PDADC  82 Value 217 | PDADC  83 Value 217 |
> ath: PDADC (0,   0): a2d4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  84 Value 217 | PDADC  85 Value 217 | PDADC  86 Value 217 | PDADC  87 Value 217 |
> ath: PDADC (0,   0): a2d8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  88 Value 217 | PDADC  89 Value 217 | PDADC  90 Value 217 | PDADC  91 Value 217 |
> ath: PDADC (0,   0): a2dc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  92 Value 217 | PDADC  93 Value 217 | PDADC  94 Value 217 | PDADC  95 Value 217 |
> ath: PDADC (0,   0): a2e0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  96 Value 217 | PDADC  97 Value 217 | PDADC  98 Value 217 | PDADC  99 Value 217 |
> ath: PDADC (0,   0): a2e4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 100 Value 217 | PDADC 101 Value 217 | PDADC 102 Value 217 | PDADC 103 Value 217 |
> ath: PDADC (0,   0): a2e8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 104 Value 217 | PDADC 105 Value 217 | PDADC 106 Value 217 | PDADC 107 Value 217 |
> ath: PDADC (0,   0): a2ec d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 108 Value 217 | PDADC 109 Value 217 | PDADC 110 Value 217 | PDADC 111 Value 217 |
> ath: PDADC (0,   0): a2f0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 112 Value 217 | PDADC 113 Value 217 | PDADC 114 Value 217 | PDADC 115 Value 217 |
> ath: PDADC (0,   0): a2f4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 116 Value 217 | PDADC 117 Value 217 | PDADC 118 Value 217 | PDADC 119 Value 217 |
> ath: PDADC (0,   0): a2f8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 120 Value 217 | PDADC 121 Value 217 | PDADC 122 Value 217 | PDADC 123 Value 217 |
> ath: PDADC (0,   0): a2fc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 124 Value 217 | PDADC 125 Value 217 | PDADC 126 Value 217 | PDADC 127 Value 217 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2422 MHz
> ath: (2417 MHz) -> (2422 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 04030201
> ath: PDADC: Chain 0 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
> ath: PDADC (0,   0): a284 08070605
> ath: PDADC: Chain 0 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   7 | PDADC   7 Value   8 |
> ath: PDADC (0,   0): a288 0c0a0909
> ath: PDADC: Chain 0 | PDADC   8 Value   9 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
> ath: PDADC (0,   0): a28c 0f0e0d0d
> ath: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  13 | PDADC  14 Value  14 | PDADC  15 Value  15 |
> ath: PDADC (0,   0): a290 15131210
> ath: PDADC: Chain 0 | PDADC  16 Value  16 | PDADC  17 Value  18 | PDADC  18 Value  19 | PDADC  19 Value  21 |
> ath: PDADC (0,   0): a294 201c1917
> ath: PDADC: Chain 0 | PDADC  20 Value  23 | PDADC  21 Value  25 | PDADC  22 Value  28 | PDADC  23 Value  32 |
> ath: PDADC (0,   0): a298 2e2b2723
> ath: PDADC: Chain 0 | PDADC  24 Value  35 | PDADC  25 Value  39 | PDADC  26 Value  43 | PDADC  27 Value  46 |
> ath: PDADC (0,   0): a29c 3e393532
> ath: PDADC: Chain 0 | PDADC  28 Value  50 | PDADC  29 Value  53 | PDADC  30 Value  57 | PDADC  31 Value  62 |
> ath: PDADC (0,   0): a2a0 58524b45
> ath: PDADC: Chain 0 | PDADC  32 Value  69 | PDADC  33 Value  75 | PDADC  34 Value  82 | PDADC  35 Value  88 |
> ath: PDADC (0,   0): a2a4 746d665f
> ath: PDADC: Chain 0 | PDADC  36 Value  95 | PDADC  37 Value 102 | PDADC  38 Value 109 | PDADC  39 Value 116 |
> ath: PDADC (0,   0): a2a8 9089827b
> ath: PDADC: Chain 0 | PDADC  40 Value 123 | PDADC  41 Value 130 | PDADC  42 Value 137 | PDADC  43 Value 144 |
> ath: PDADC (0,   0): a2ac 2b272397
> ath: PDADC: Chain 0 | PDADC  44 Value 151 | PDADC  45 Value  35 | PDADC  46 Value  39 | PDADC  47 Value  43 |
> ath: PDADC (0,   0): a2b0 3b37332f
> ath: PDADC: Chain 0 | PDADC  48 Value  47 | PDADC  49 Value  51 | PDADC  50 Value  55 | PDADC  51 Value  59 |
> ath: PDADC (0,   0): a2b4 4c47423e
> ath: PDADC: Chain 0 | PDADC  52 Value  62 | PDADC  53 Value  66 | PDADC  54 Value  71 | PDADC  55 Value  76 |
> ath: PDADC (0,   0): a2b8 645e5852
> ath: PDADC: Chain 0 | PDADC  56 Value  82 | PDADC  57 Value  88 | PDADC  58 Value  94 | PDADC  59 Value 100 |
> ath: PDADC (0,   0): a2bc 857d756c
> ath: PDADC: Chain 0 | PDADC  60 Value 108 | PDADC  61 Value 117 | PDADC  62 Value 125 | PDADC  63 Value 133 |
> ath: PDADC (0,   0): a2c0 a89f968e
> ath: PDADC: Chain 0 | PDADC  64 Value 142 | PDADC  65 Value 150 | PDADC  66 Value 159 | PDADC  67 Value 168 |
> ath: PDADC (0,   0): a2c4 c8c0b8b0
> ath: PDADC: Chain 0 | PDADC  68 Value 176 | PDADC  69 Value 184 | PDADC  70 Value 192 | PDADC  71 Value 200 |
> ath: PDADC (0,   0): a2c8 e0e0d8d0
> ath: PDADC: Chain 0 | PDADC  72 Value 208 | PDADC  73 Value 216 | PDADC  74 Value 224 | PDADC  75 Value 224 |
> ath: PDADC (0,   0): a2cc e0e0e0e0
> ath: PDADC: Chain 0 | PDADC  76 Value 224 | PDADC  77 Value 224 | PDADC  78 Value 224 | PDADC  79 Value 224 |
> ath: PDADC (0,   0): a2d0 e0e0e0e0
> ath: PDADC: Chain 0 | PDADC  80 Value 224 | PDADC  81 Value 224 | PDADC  82 Value 224 | PDADC  83 Value 224 |
> ath: PDADC (0,   0): a2d4 e0e0e0e0
> ath: PDADC: Chain 0 | PDADC  84 Value 224 | PDADC  85 Value 224 | PDADC  86 Value 224 | PDADC  87 Value 224 |
> ath: PDADC (0,   0): a2d8 e0e0e0e0
> ath: PDADC: Chain 0 | PDADC  88 Value 224 | PDADC  89 Value 224 | PDADC  90 Value 224 | PDADC  91 Value 224 |
> ath: PDADC (0,   0): a2dc e0e0e0e0
> ath: PDADC: Chain 0 | PDADC  92 Value 224 | PDADC  93 Value 224 | PDADC  94 Value 224 | PDADC  95 Value 224 |
> ath: PDADC (0,   0): a2e0 e0e0e0e0
> ath: PDADC: Chain 0 | PDADC  96 Value 224 | PDADC  97 Value 224 | PDADC  98 Value 224 | PDADC  99 Value 224 |
> ath: PDADC (0,   0): a2e4 e0e0e0e0
> ath: PDADC: Chain 0 | PDADC 100 Value 224 | PDADC 101 Value 224 | PDADC 102 Value 224 | PDADC 103 Value 224 |
> ath: PDADC (0,   0): a2e8 e0e0e0e0
> ath: PDADC: Chain 0 | PDADC 104 Value 224 | PDADC 105 Value 224 | PDADC 106 Value 224 | PDADC 107 Value 224 |
> ath: PDADC (0,   0): a2ec e0e0e0e0
> ath: PDADC: Chain 0 | PDADC 108 Value 224 | PDADC 109 Value 224 | PDADC 110 Value 224 | PDADC 111 Value 224 |
> ath: PDADC (0,   0): a2f0 e0e0e0e0
> ath: PDADC: Chain 0 | PDADC 112 Value 224 | PDADC 113 Value 224 | PDADC 114 Value 224 | PDADC 115 Value 224 |
> ath: PDADC (0,   0): a2f4 e0e0e0e0
> ath: PDADC: Chain 0 | PDADC 116 Value 224 | PDADC 117 Value 224 | PDADC 118 Value 224 | PDADC 119 Value 224 |
> ath: PDADC (0,   0): a2f8 e0e0e0e0
> ath: PDADC: Chain 0 | PDADC 120 Value 224 | PDADC 121 Value 224 | PDADC 122 Value 224 | PDADC 123 Value 224 |
> ath: PDADC (0,   0): a2fc e0e0e0e0
> ath: PDADC: Chain 0 | PDADC 124 Value 224 | PDADC 125 Value 224 | PDADC 126 Value 224 | PDADC 127 Value 224 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2427 MHz
> ath: (2422 MHz) -> (2427 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 04030201
> ath: PDADC: Chain 0 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
> ath: PDADC (0,   0): a284 07070605
> ath: PDADC: Chain 0 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   7 | PDADC   7 Value   7 |
> ath: PDADC (0,   0): a288 0b0a0908
> ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
> ath: PDADC (0,   0): a28c 0d0d0c0c
> ath: PDADC: Chain 0 | PDADC  12 Value  12 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  13 |
> ath: PDADC (0,   0): a290 1412100f
> ath: PDADC: Chain 0 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  18 | PDADC  19 Value  20 |
> ath: PDADC (0,   0): a294 1f1b1816
> ath: PDADC: Chain 0 | PDADC  20 Value  22 | PDADC  21 Value  24 | PDADC  22 Value  27 | PDADC  23 Value  31 |
> ath: PDADC (0,   0): a298 2e2a2622
> ath: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  38 | PDADC  26 Value  42 | PDADC  27 Value  46 |
> ath: PDADC (0,   0): a29c 3e393531
> ath: PDADC: Chain 0 | PDADC  28 Value  49 | PDADC  29 Value  53 | PDADC  30 Value  57 | PDADC  31 Value  62 |
> ath: PDADC (0,   0): a2a0 58514b44
> ath: PDADC: Chain 0 | PDADC  32 Value  68 | PDADC  33 Value  75 | PDADC  34 Value  81 | PDADC  35 Value  88 |
> ath: PDADC (0,   0): a2a4 736c655e
> ath: PDADC: Chain 0 | PDADC  36 Value  94 | PDADC  37 Value 101 | PDADC  38 Value 108 | PDADC  39 Value 115 |
> ath: PDADC (0,   0): a2a8 8f88817a
> ath: PDADC: Chain 0 | PDADC  40 Value 122 | PDADC  41 Value 129 | PDADC  42 Value 136 | PDADC  43 Value 143 |
> ath: PDADC (0,   0): a2ac 2a262296
> ath: PDADC: Chain 0 | PDADC  44 Value 150 | PDADC  45 Value  34 | PDADC  46 Value  38 | PDADC  47 Value  42 |
> ath: PDADC (0,   0): a2b0 3a36322e
> ath: PDADC: Chain 0 | PDADC  48 Value  46 | PDADC  49 Value  50 | PDADC  50 Value  54 | PDADC  51 Value  58 |
> ath: PDADC (0,   0): a2b4 4c46423d
> ath: PDADC: Chain 0 | PDADC  52 Value  61 | PDADC  53 Value  66 | PDADC  54 Value  70 | PDADC  55 Value  76 |
> ath: PDADC (0,   0): a2b8 635d5751
> ath: PDADC: Chain 0 | PDADC  56 Value  81 | PDADC  57 Value  87 | PDADC  58 Value  93 | PDADC  59 Value  99 |
> ath: PDADC (0,   0): a2bc 847c746b
> ath: PDADC: Chain 0 | PDADC  60 Value 107 | PDADC  61 Value 116 | PDADC  62 Value 124 | PDADC  63 Value 132 |
> ath: PDADC (0,   0): a2c0 a89e958c
> ath: PDADC: Chain 0 | PDADC  64 Value 140 | PDADC  65 Value 149 | PDADC  66 Value 158 | PDADC  67 Value 168 |
> ath: PDADC (0,   0): a2c4 ccc3bab1
> ath: PDADC: Chain 0 | PDADC  68 Value 177 | PDADC  69 Value 186 | PDADC  70 Value 195 | PDADC  71 Value 204 |
> ath: PDADC (0,   0): a2c8 e7e7ded5
> ath: PDADC: Chain 0 | PDADC  72 Value 213 | PDADC  73 Value 222 | PDADC  74 Value 231 | PDADC  75 Value 231 |
> ath: PDADC (0,   0): a2cc e7e7e7e7
> ath: PDADC: Chain 0 | PDADC  76 Value 231 | PDADC  77 Value 231 | PDADC  78 Value 231 | PDADC  79 Value 231 |
> ath: PDADC (0,   0): a2d0 e7e7e7e7
> ath: PDADC: Chain 0 | PDADC  80 Value 231 | PDADC  81 Value 231 | PDADC  82 Value 231 | PDADC  83 Value 231 |
> ath: PDADC (0,   0): a2d4 e7e7e7e7
> ath: PDADC: Chain 0 | PDADC  84 Value 231 | PDADC  85 Value 231 | PDADC  86 Value 231 | PDADC  87 Value 231 |
> ath: PDADC (0,   0): a2d8 e7e7e7e7
> ath: PDADC: Chain 0 | PDADC  88 Value 231 | PDADC  89 Value 231 | PDADC  90 Value 231 | PDADC  91 Value 231 |
> ath: PDADC (0,   0): a2dc e7e7e7e7
> ath: PDADC: Chain 0 | PDADC  92 Value 231 | PDADC  93 Value 231 | PDADC  94 Value 231 | PDADC  95 Value 231 |
> ath: PDADC (0,   0): a2e0 e7e7e7e7
> ath: PDADC: Chain 0 | PDADC  96 Value 231 | PDADC  97 Value 231 | PDADC  98 Value 231 | PDADC  99 Value 231 |
> ath: PDADC (0,   0): a2e4 e7e7e7e7
> ath: PDADC: Chain 0 | PDADC 100 Value 231 | PDADC 101 Value 231 | PDADC 102 Value 231 | PDADC 103 Value 231 |
> ath: PDADC (0,   0): a2e8 e7e7e7e7
> ath: PDADC: Chain 0 | PDADC 104 Value 231 | PDADC 105 Value 231 | PDADC 106 Value 231 | PDADC 107 Value 231 |
> ath: PDADC (0,   0): a2ec e7e7e7e7
> ath: PDADC: Chain 0 | PDADC 108 Value 231 | PDADC 109 Value 231 | PDADC 110 Value 231 | PDADC 111 Value 231 |
> ath: PDADC (0,   0): a2f0 e7e7e7e7
> ath: PDADC: Chain 0 | PDADC 112 Value 231 | PDADC 113 Value 231 | PDADC 114 Value 231 | PDADC 115 Value 231 |
> ath: PDADC (0,   0): a2f4 e7e7e7e7
> ath: PDADC: Chain 0 | PDADC 116 Value 231 | PDADC 117 Value 231 | PDADC 118 Value 231 | PDADC 119 Value 231 |
> ath: PDADC (0,   0): a2f8 e7e7e7e7
> ath: PDADC: Chain 0 | PDADC 120 Value 231 | PDADC 121 Value 231 | PDADC 122 Value 231 | PDADC 123 Value 231 |
> ath: PDADC (0,   0): a2fc e7e7e7e7
> ath: PDADC: Chain 0 | PDADC 124 Value 231 | PDADC 125 Value 231 | PDADC 126 Value 231 | PDADC 127 Value 231 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2432 MHz
> ath: (2427 MHz) -> (2432 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 04030201
> ath: PDADC: Chain 0 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
> ath: PDADC (0,   0): a284 07070605
> ath: PDADC: Chain 0 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   7 | PDADC   7 Value   7 |
> ath: PDADC (0,   0): a288 0a090808
> ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   8 | PDADC  10 Value   9 | PDADC  11 Value  10 |
> ath: PDADC (0,   0): a28c 0c0c0b0b
> ath: PDADC: Chain 0 | PDADC  12 Value  11 | PDADC  13 Value  11 | PDADC  14 Value  12 | PDADC  15 Value  12 |
> ath: PDADC (0,   0): a290 13110f0d
> ath: PDADC: Chain 0 | PDADC  16 Value  13 | PDADC  17 Value  15 | PDADC  18 Value  17 | PDADC  19 Value  19 |
> ath: PDADC (0,   0): a294 1f1b1715
> ath: PDADC: Chain 0 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  27 | PDADC  23 Value  31 |
> ath: PDADC (0,   0): a298 2e2a2622
> ath: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  38 | PDADC  26 Value  42 | PDADC  27 Value  46 |
> ath: PDADC (0,   0): a29c 3e393531
> ath: PDADC: Chain 0 | PDADC  28 Value  49 | PDADC  29 Value  53 | PDADC  30 Value  57 | PDADC  31 Value  62 |
> ath: PDADC (0,   0): a2a0 57514a44
> ath: PDADC: Chain 0 | PDADC  32 Value  68 | PDADC  33 Value  74 | PDADC  34 Value  81 | PDADC  35 Value  87 |
> ath: PDADC (0,   0): a2a4 726b645d
> ath: PDADC: Chain 0 | PDADC  36 Value  93 | PDADC  37 Value 100 | PDADC  38 Value 107 | PDADC  39 Value 114 |
> ath: PDADC (0,   0): a2a8 8e878079
> ath: PDADC: Chain 0 | PDADC  40 Value 121 | PDADC  41 Value 128 | PDADC  42 Value 135 | PDADC  43 Value 142 |
> ath: PDADC (0,   0): a2ac 29252195
> ath: PDADC: Chain 0 | PDADC  44 Value 149 | PDADC  45 Value  33 | PDADC  46 Value  37 | PDADC  47 Value  41 |
> ath: PDADC (0,   0): a2b0 3935312d
> ath: PDADC: Chain 0 | PDADC  48 Value  45 | PDADC  49 Value  49 | PDADC  50 Value  53 | PDADC  51 Value  57 |
> ath: PDADC (0,   0): a2b4 4b46413c
> ath: PDADC: Chain 0 | PDADC  52 Value  60 | PDADC  53 Value  65 | PDADC  54 Value  70 | PDADC  55 Value  75 |
> ath: PDADC (0,   0): a2b8 625c5650
> ath: PDADC: Chain 0 | PDADC  56 Value  80 | PDADC  57 Value  86 | PDADC  58 Value  92 | PDADC  59 Value  98 |
> ath: PDADC (0,   0): a2bc 837b736a
> ath: PDADC: Chain 0 | PDADC  60 Value 106 | PDADC  61 Value 115 | PDADC  62 Value 123 | PDADC  63 Value 131 |
> ath: PDADC (0,   0): a2c0 a89d948b
> ath: PDADC: Chain 0 | PDADC  64 Value 139 | PDADC  65 Value 148 | PDADC  66 Value 157 | PDADC  67 Value 168 |
> ath: PDADC (0,   0): a2c4 d0c6bcb2
> ath: PDADC: Chain 0 | PDADC  68 Value 178 | PDADC  69 Value 188 | PDADC  70 Value 198 | PDADC  71 Value 208 |
> ath: PDADC (0,   0): a2c8 eeeee4da
> ath: PDADC: Chain 0 | PDADC  72 Value 218 | PDADC  73 Value 228 | PDADC  74 Value 238 | PDADC  75 Value 238 |
> ath: PDADC (0,   0): a2cc eeeeeeee
> ath: PDADC: Chain 0 | PDADC  76 Value 238 | PDADC  77 Value 238 | PDADC  78 Value 238 | PDADC  79 Value 238 |
> ath: PDADC (0,   0): a2d0 eeeeeeee
> ath: PDADC: Chain 0 | PDADC  80 Value 238 | PDADC  81 Value 238 | PDADC  82 Value 238 | PDADC  83 Value 238 |
> ath: PDADC (0,   0): a2d4 eeeeeeee
> ath: PDADC: Chain 0 | PDADC  84 Value 238 | PDADC  85 Value 238 | PDADC  86 Value 238 | PDADC  87 Value 238 |
> ath: PDADC (0,   0): a2d8 eeeeeeee
> ath: PDADC: Chain 0 | PDADC  88 Value 238 | PDADC  89 Value 238 | PDADC  90 Value 238 | PDADC  91 Value 238 |
> ath: PDADC (0,   0): a2dc eeeeeeee
> ath: PDADC: Chain 0 | PDADC  92 Value 238 | PDADC  93 Value 238 | PDADC  94 Value 238 | PDADC  95 Value 238 |
> ath: PDADC (0,   0): a2e0 eeeeeeee
> ath: PDADC: Chain 0 | PDADC  96 Value 238 | PDADC  97 Value 238 | PDADC  98 Value 238 | PDADC  99 Value 238 |
> ath: PDADC (0,   0): a2e4 eeeeeeee
> ath: PDADC: Chain 0 | PDADC 100 Value 238 | PDADC 101 Value 238 | PDADC 102 Value 238 | PDADC 103 Value 238 |
> ath: PDADC (0,   0): a2e8 eeeeeeee
> ath: PDADC: Chain 0 | PDADC 104 Value 238 | PDADC 105 Value 238 | PDADC 106 Value 238 | PDADC 107 Value 238 |
> ath: PDADC (0,   0): a2ec eeeeeeee
> ath: PDADC: Chain 0 | PDADC 108 Value 238 | PDADC 109 Value 238 | PDADC 110 Value 238 | PDADC 111 Value 238 |
> ath: PDADC (0,   0): a2f0 eeeeeeee
> ath: PDADC: Chain 0 | PDADC 112 Value 238 | PDADC 113 Value 238 | PDADC 114 Value 238 | PDADC 115 Value 238 |
> ath: PDADC (0,   0): a2f4 eeeeeeee
> ath: PDADC: Chain 0 | PDADC 116 Value 238 | PDADC 117 Value 238 | PDADC 118 Value 238 | PDADC 119 Value 238 |
> ath: PDADC (0,   0): a2f8 eeeeeeee
> ath: PDADC: Chain 0 | PDADC 120 Value 238 | PDADC 121 Value 238 | PDADC 122 Value 238 | PDADC 123 Value 238 |
> ath: PDADC (0,   0): a2fc eeeeeeee
> ath: PDADC: Chain 0 | PDADC 124 Value 238 | PDADC 125 Value 238 | PDADC 126 Value 238 | PDADC 127 Value 238 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2437 MHz
> ath: (2432 MHz) -> (2437 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 05040302
> ath: PDADC: Chain 0 | PDADC   0 Value   2 | PDADC   1 Value   3 | PDADC   2 Value   4 | PDADC   3 Value   5 |
> ath: PDADC (0,   0): a284 07070606
> ath: PDADC: Chain 0 | PDADC   4 Value   6 | PDADC   5 Value   6 | PDADC   6 Value   7 | PDADC   7 Value   7 |
> ath: PDADC (0,   0): a288 09090808
> ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   8 | PDADC  10 Value   9 | PDADC  11 Value   9 |
> ath: PDADC (0,   0): a28c 0b0b0a0a
> ath: PDADC: Chain 0 | PDADC  12 Value  10 | PDADC  13 Value  10 | PDADC  14 Value  11 | PDADC  15 Value  11 |
> ath: PDADC (0,   0): a290 12100e0c
> ath: PDADC: Chain 0 | PDADC  16 Value  12 | PDADC  17 Value  14 | PDADC  18 Value  16 | PDADC  19 Value  18 |
> ath: PDADC (0,   0): a294 1f1b1714
> ath: PDADC: Chain 0 | PDADC  20 Value  20 | PDADC  21 Value  23 | PDADC  22 Value  27 | PDADC  23 Value  31 |
> ath: PDADC (0,   0): a298 2e2a2622
> ath: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  38 | PDADC  26 Value  42 | PDADC  27 Value  46 |
> ath: PDADC (0,   0): a29c 3e393531
> ath: PDADC: Chain 0 | PDADC  28 Value  49 | PDADC  29 Value  53 | PDADC  30 Value  57 | PDADC  31 Value  62 |
> ath: PDADC (0,   0): a2a0 57514a44
> ath: PDADC: Chain 0 | PDADC  32 Value  68 | PDADC  33 Value  74 | PDADC  34 Value  81 | PDADC  35 Value  87 |
> ath: PDADC (0,   0): a2a4 716a645d
> ath: PDADC: Chain 0 | PDADC  36 Value  93 | PDADC  37 Value 100 | PDADC  38 Value 106 | PDADC  39 Value 113 |
> ath: PDADC (0,   0): a2a8 8d867f78
> ath: PDADC: Chain 0 | PDADC  40 Value 120 | PDADC  41 Value 127 | PDADC  42 Value 134 | PDADC  43 Value 141 |
> ath: PDADC (0,   0): a2ac 2a26221e
> ath: PDADC: Chain 0 | PDADC  44 Value  30 | PDADC  45 Value  34 | PDADC  46 Value  38 | PDADC  47 Value  42 |
> ath: PDADC (0,   0): a2b0 3a36322e
> ath: PDADC: Chain 0 | PDADC  48 Value  46 | PDADC  49 Value  50 | PDADC  50 Value  54 | PDADC  51 Value  58 |
> ath: PDADC (0,   0): a2b4 4e48433e
> ath: PDADC: Chain 0 | PDADC  52 Value  62 | PDADC  53 Value  67 | PDADC  54 Value  72 | PDADC  55 Value  78 |
> ath: PDADC (0,   0): a2b8 665e5853
> ath: PDADC: Chain 0 | PDADC  56 Value  83 | PDADC  57 Value  88 | PDADC  58 Value  94 | PDADC  59 Value 102 |
> ath: PDADC (0,   0): a2bc 867e766e
> ath: PDADC: Chain 0 | PDADC  60 Value 110 | PDADC  61 Value 118 | PDADC  62 Value 126 | PDADC  63 Value 134 |
> ath: PDADC (0,   0): a2c0 ada3988e
> ath: PDADC: Chain 0 | PDADC  64 Value 142 | PDADC  65 Value 152 | PDADC  66 Value 163 | PDADC  67 Value 173 |
> ath: PDADC (0,   0): a2c4 d5cbc1b7
> ath: PDADC: Chain 0 | PDADC  68 Value 183 | PDADC  69 Value 193 | PDADC  70 Value 203 | PDADC  71 Value 213 |
> ath: PDADC (0,   0): a2c8 f3f3e9df
> ath: PDADC: Chain 0 | PDADC  72 Value 223 | PDADC  73 Value 233 | PDADC  74 Value 243 | PDADC  75 Value 243 |
> ath: PDADC (0,   0): a2cc f3f3f3f3
> ath: PDADC: Chain 0 | PDADC  76 Value 243 | PDADC  77 Value 243 | PDADC  78 Value 243 | PDADC  79 Value 243 |
> ath: PDADC (0,   0): a2d0 f3f3f3f3
> ath: PDADC: Chain 0 | PDADC  80 Value 243 | PDADC  81 Value 243 | PDADC  82 Value 243 | PDADC  83 Value 243 |
> ath: PDADC (0,   0): a2d4 f3f3f3f3
> ath: PDADC: Chain 0 | PDADC  84 Value 243 | PDADC  85 Value 243 | PDADC  86 Value 243 | PDADC  87 Value 243 |
> ath: PDADC (0,   0): a2d8 f3f3f3f3
> ath: PDADC: Chain 0 | PDADC  88 Value 243 | PDADC  89 Value 243 | PDADC  90 Value 243 | PDADC  91 Value 243 |
> ath: PDADC (0,   0): a2dc f3f3f3f3
> ath: PDADC: Chain 0 | PDADC  92 Value 243 | PDADC  93 Value 243 | PDADC  94 Value 243 | PDADC  95 Value 243 |
> ath: PDADC (0,   0): a2e0 f3f3f3f3
> ath: PDADC: Chain 0 | PDADC  96 Value 243 | PDADC  97 Value 243 | PDADC  98 Value 243 | PDADC  99 Value 243 |
> ath: PDADC (0,   0): a2e4 f3f3f3f3
> ath: PDADC: Chain 0 | PDADC 100 Value 243 | PDADC 101 Value 243 | PDADC 102 Value 243 | PDADC 103 Value 243 |
> ath: PDADC (0,   0): a2e8 f3f3f3f3
> ath: PDADC: Chain 0 | PDADC 104 Value 243 | PDADC 105 Value 243 | PDADC 106 Value 243 | PDADC 107 Value 243 |
> ath: PDADC (0,   0): a2ec f3f3f3f3
> ath: PDADC: Chain 0 | PDADC 108 Value 243 | PDADC 109 Value 243 | PDADC 110 Value 243 | PDADC 111 Value 243 |
> ath: PDADC (0,   0): a2f0 f3f3f3f3
> ath: PDADC: Chain 0 | PDADC 112 Value 243 | PDADC 113 Value 243 | PDADC 114 Value 243 | PDADC 115 Value 243 |
> ath: PDADC (0,   0): a2f4 f3f3f3f3
> ath: PDADC: Chain 0 | PDADC 116 Value 243 | PDADC 117 Value 243 | PDADC 118 Value 243 | PDADC 119 Value 243 |
> ath: PDADC (0,   0): a2f8 f3f3f3f3
> ath: PDADC: Chain 0 | PDADC 120 Value 243 | PDADC 121 Value 243 | PDADC 122 Value 243 | PDADC 123 Value 243 |
> ath: PDADC (0,   0): a2fc f3f3f3f3
> ath: PDADC: Chain 0 | PDADC 124 Value 243 | PDADC 125 Value 243 | PDADC 126 Value 243 | PDADC 127 Value 243 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2442 MHz
> ath: (2437 MHz) -> (2442 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 05040302
> ath: PDADC: Chain 0 | PDADC   0 Value   2 | PDADC   1 Value   3 | PDADC   2 Value   4 | PDADC   3 Value   5 |
> ath: PDADC (0,   0): a284 07070606
> ath: PDADC: Chain 0 | PDADC   4 Value   6 | PDADC   5 Value   6 | PDADC   6 Value   7 | PDADC   7 Value   7 |
> ath: PDADC (0,   0): a288 09090808
> ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   8 | PDADC  10 Value   9 | PDADC  11 Value   9 |
> ath: PDADC (0,   0): a28c 0b0b0a0a
> ath: PDADC: Chain 0 | PDADC  12 Value  10 | PDADC  13 Value  10 | PDADC  14 Value  11 | PDADC  15 Value  11 |
> ath: PDADC (0,   0): a290 12100e0d
> ath: PDADC: Chain 0 | PDADC  16 Value  13 | PDADC  17 Value  14 | PDADC  18 Value  16 | PDADC  19 Value  18 |
> ath: PDADC (0,   0): a294 1f1b1714
> ath: PDADC: Chain 0 | PDADC  20 Value  20 | PDADC  21 Value  23 | PDADC  22 Value  27 | PDADC  23 Value  31 |
> ath: PDADC (0,   0): a298 2e2a2622
> ath: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  38 | PDADC  26 Value  42 | PDADC  27 Value  46 |
> ath: PDADC (0,   0): a29c 3f393531
> ath: PDADC: Chain 0 | PDADC  28 Value  49 | PDADC  29 Value  53 | PDADC  30 Value  57 | PDADC  31 Value  63 |
> ath: PDADC (0,   0): a2a0 57514b45
> ath: PDADC: Chain 0 | PDADC  32 Value  69 | PDADC  33 Value  75 | PDADC  34 Value  81 | PDADC  35 Value  87 |
> ath: PDADC (0,   0): a2a4 706a645d
> ath: PDADC: Chain 0 | PDADC  36 Value  93 | PDADC  37 Value 100 | PDADC  38 Value 106 | PDADC  39 Value 112 |
> ath: PDADC (0,   0): a2a8 88827c76
> ath: PDADC: Chain 0 | PDADC  40 Value 118 | PDADC  41 Value 124 | PDADC  42 Value 130 | PDADC  43 Value 136 |
> ath: PDADC (0,   0): a2ac 29241f1a
> ath: PDADC: Chain 0 | PDADC  44 Value  26 | PDADC  45 Value  31 | PDADC  46 Value  36 | PDADC  47 Value  41 |
> ath: PDADC (0,   0): a2b0 3b37332e
> ath: PDADC: Chain 0 | PDADC  48 Value  46 | PDADC  49 Value  51 | PDADC  50 Value  55 | PDADC  51 Value  59 |
> ath: PDADC (0,   0): a2b4 4f49443f
> ath: PDADC: Chain 0 | PDADC  52 Value  63 | PDADC  53 Value  68 | PDADC  54 Value  73 | PDADC  55 Value  79 |
> ath: PDADC (0,   0): a2b8 68605a55
> ath: PDADC: Chain 0 | PDADC  56 Value  85 | PDADC  57 Value  90 | PDADC  58 Value  96 | PDADC  59 Value 104 |
> ath: PDADC (0,   0): a2bc 89817870
> ath: PDADC: Chain 0 | PDADC  60 Value 112 | PDADC  61 Value 120 | PDADC  62 Value 129 | PDADC  63 Value 137 |
> ath: PDADC (0,   0): a2c0 afa59b91
> ath: PDADC: Chain 0 | PDADC  64 Value 145 | PDADC  65 Value 155 | PDADC  66 Value 165 | PDADC  67 Value 175 |
> ath: PDADC (0,   0): a2c4 d7cdc3b9
> ath: PDADC: Chain 0 | PDADC  68 Value 185 | PDADC  69 Value 195 | PDADC  70 Value 205 | PDADC  71 Value 215 |
> ath: PDADC (0,   0): a2c8 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC  72 Value 215 | PDADC  73 Value 215 | PDADC  74 Value 215 | PDADC  75 Value 215 |
> ath: PDADC (0,   0): a2cc d7d7d7d7
> ath: PDADC: Chain 0 | PDADC  76 Value 215 | PDADC  77 Value 215 | PDADC  78 Value 215 | PDADC  79 Value 215 |
> ath: PDADC (0,   0): a2d0 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC  80 Value 215 | PDADC  81 Value 215 | PDADC  82 Value 215 | PDADC  83 Value 215 |
> ath: PDADC (0,   0): a2d4 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC  84 Value 215 | PDADC  85 Value 215 | PDADC  86 Value 215 | PDADC  87 Value 215 |
> ath: PDADC (0,   0): a2d8 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC  88 Value 215 | PDADC  89 Value 215 | PDADC  90 Value 215 | PDADC  91 Value 215 |
> ath: PDADC (0,   0): a2dc d7d7d7d7
> ath: PDADC: Chain 0 | PDADC  92 Value 215 | PDADC  93 Value 215 | PDADC  94 Value 215 | PDADC  95 Value 215 |
> ath: PDADC (0,   0): a2e0 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC  96 Value 215 | PDADC  97 Value 215 | PDADC  98 Value 215 | PDADC  99 Value 215 |
> ath: PDADC (0,   0): a2e4 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC 100 Value 215 | PDADC 101 Value 215 | PDADC 102 Value 215 | PDADC 103 Value 215 |
> ath: PDADC (0,   0): a2e8 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC 104 Value 215 | PDADC 105 Value 215 | PDADC 106 Value 215 | PDADC 107 Value 215 |
> ath: PDADC (0,   0): a2ec d7d7d7d7
> ath: PDADC: Chain 0 | PDADC 108 Value 215 | PDADC 109 Value 215 | PDADC 110 Value 215 | PDADC 111 Value 215 |
> ath: PDADC (0,   0): a2f0 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC 112 Value 215 | PDADC 113 Value 215 | PDADC 114 Value 215 | PDADC 115 Value 215 |
> ath: PDADC (0,   0): a2f4 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC 116 Value 215 | PDADC 117 Value 215 | PDADC 118 Value 215 | PDADC 119 Value 215 |
> ath: PDADC (0,   0): a2f8 d7d7d7d7
> ath: PDADC: Chain 0 | PDADC 120 Value 215 | PDADC 121 Value 215 | PDADC 122 Value 215 | PDADC 123 Value 215 |
> ath: PDADC (0,   0): a2fc d7d7d7d7
> ath: PDADC: Chain 0 | PDADC 124 Value 215 | PDADC 125 Value 215 | PDADC 126 Value 215 | PDADC 127 Value 215 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2447 MHz
> ath: (2442 MHz) -> (2447 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -116
> ath: PDADC (0,   0): a280 05040302
> ath: PDADC: Chain 0 | PDADC   0 Value   2 | PDADC   1 Value   3 | PDADC   2 Value   4 | PDADC   3 Value   5 |
> ath: PDADC (0,   0): a284 07070606
> ath: PDADC: Chain 0 | PDADC   4 Value   6 | PDADC   5 Value   6 | PDADC   6 Value   7 | PDADC   7 Value   7 |
> ath: PDADC (0,   0): a288 09090808
> ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   8 | PDADC  10 Value   9 | PDADC  11 Value   9 |
> ath: PDADC (0,   0): a28c 0c0c0b0b
> ath: PDADC: Chain 0 | PDADC  12 Value  11 | PDADC  13 Value  11 | PDADC  14 Value  12 | PDADC  15 Value  12 |
> ath: PDADC (0,   0): a290 13110f0e
> ath: PDADC: Chain 0 | PDADC  16 Value  14 | PDADC  17 Value  15 | PDADC  18 Value  17 | PDADC  19 Value  19 |
> ath: PDADC (0,   0): a294 201c1815
> ath: PDADC: Chain 0 | PDADC  20 Value  21 | PDADC  21 Value  24 | PDADC  22 Value  28 | PDADC  23 Value  32 |
> ath: PDADC (0,   0): a298 2f2b2723
> ath: PDADC: Chain 0 | PDADC  24 Value  35 | PDADC  25 Value  39 | PDADC  26 Value  43 | PDADC  27 Value  47 |
> ath: PDADC (0,   0): a29c 403a3632
> ath: PDADC: Chain 0 | PDADC  28 Value  50 | PDADC  29 Value  54 | PDADC  30 Value  58 | PDADC  31 Value  64 |
> ath: PDADC (0,   0): a2a0 58524c46
> ath: PDADC: Chain 0 | PDADC  32 Value  70 | PDADC  33 Value  76 | PDADC  34 Value  82 | PDADC  35 Value  88 |
> ath: PDADC (0,   0): a2a4 716b655e
> ath: PDADC: Chain 0 | PDADC  36 Value  94 | PDADC  37 Value 101 | PDADC  38 Value 107 | PDADC  39 Value 113 |
> ath: PDADC (0,   0): a2a8 89837d77
> ath: PDADC: Chain 0 | PDADC  40 Value 119 | PDADC  41 Value 125 | PDADC  42 Value 131 | PDADC  43 Value 137 |
> ath: PDADC (0,   0): a2ac 2a25201b
> ath: PDADC: Chain 0 | PDADC  44 Value  27 | PDADC  45 Value  32 | PDADC  46 Value  37 | PDADC  47 Value  42 |
> ath: PDADC (0,   0): a2b0 3c38342f
> ath: PDADC: Chain 0 | PDADC  48 Value  47 | PDADC  49 Value  52 | PDADC  50 Value  56 | PDADC  51 Value  60 |
> ath: PDADC (0,   0): a2b4 514b4641
> ath: PDADC: Chain 0 | PDADC  52 Value  65 | PDADC  53 Value  70 | PDADC  54 Value  75 | PDADC  55 Value  81 |
> ath: PDADC (0,   0): a2b8 6a625c57
> ath: PDADC: Chain 0 | PDADC  56 Value  87 | PDADC  57 Value  92 | PDADC  58 Value  98 | PDADC  59 Value 106 |
> ath: PDADC (0,   0): a2bc 8c847b72
> ath: PDADC: Chain 0 | PDADC  60 Value 114 | PDADC  61 Value 123 | PDADC  62 Value 132 | PDADC  63 Value 140 |
> ath: PDADC (0,   0): a2c0 b0a79e95
> ath: PDADC: Chain 0 | PDADC  64 Value 149 | PDADC  65 Value 158 | PDADC  66 Value 167 | PDADC  67 Value 176 |
> ath: PDADC (0,   0): a2c4 d4cbc2b9
> ath: PDADC: Chain 0 | PDADC  68 Value 185 | PDADC  69 Value 194 | PDADC  70 Value 203 | PDADC  71 Value 212 |
> ath: PDADC (0,   0): a2c8 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC  72 Value 212 | PDADC  73 Value 212 | PDADC  74 Value 212 | PDADC  75 Value 212 |
> ath: PDADC (0,   0): a2cc d4d4d4d4
> ath: PDADC: Chain 0 | PDADC  76 Value 212 | PDADC  77 Value 212 | PDADC  78 Value 212 | PDADC  79 Value 212 |
> ath: PDADC (0,   0): a2d0 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC  80 Value 212 | PDADC  81 Value 212 | PDADC  82 Value 212 | PDADC  83 Value 212 |
> ath: PDADC (0,   0): a2d4 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC  84 Value 212 | PDADC  85 Value 212 | PDADC  86 Value 212 | PDADC  87 Value 212 |
> ath: PDADC (0,   0): a2d8 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC  88 Value 212 | PDADC  89 Value 212 | PDADC  90 Value 212 | PDADC  91 Value 212 |
> ath: PDADC (0,   0): a2dc d4d4d4d4
> ath: PDADC: Chain 0 | PDADC  92 Value 212 | PDADC  93 Value 212 | PDADC  94 Value 212 | PDADC  95 Value 212 |
> ath: PDADC (0,   0): a2e0 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC  96 Value 212 | PDADC  97 Value 212 | PDADC  98 Value 212 | PDADC  99 Value 212 |
> ath: PDADC (0,   0): a2e4 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC 100 Value 212 | PDADC 101 Value 212 | PDADC 102 Value 212 | PDADC 103 Value 212 |
> ath: PDADC (0,   0): a2e8 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC 104 Value 212 | PDADC 105 Value 212 | PDADC 106 Value 212 | PDADC 107 Value 212 |
> ath: PDADC (0,   0): a2ec d4d4d4d4
> ath: PDADC: Chain 0 | PDADC 108 Value 212 | PDADC 109 Value 212 | PDADC 110 Value 212 | PDADC 111 Value 212 |
> ath: PDADC (0,   0): a2f0 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC 112 Value 212 | PDADC 113 Value 212 | PDADC 114 Value 212 | PDADC 115 Value 212 |
> ath: PDADC (0,   0): a2f4 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC 116 Value 212 | PDADC 117 Value 212 | PDADC 118 Value 212 | PDADC 119 Value 212 |
> ath: PDADC (0,   0): a2f8 d4d4d4d4
> ath: PDADC: Chain 0 | PDADC 120 Value 212 | PDADC 121 Value 212 | PDADC 122 Value 212 | PDADC 123 Value 212 |
> ath: PDADC (0,   0): a2fc d4d4d4d4
> ath: PDADC: Chain 0 | PDADC 124 Value 212 | PDADC 125 Value 212 | PDADC 126 Value 212 | PDADC 127 Value 212 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2452 MHz
> ath: (2447 MHz) -> (2452 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 05040302
> ath: PDADC: Chain 0 | PDADC   0 Value   2 | PDADC   1 Value   3 | PDADC   2 Value   4 | PDADC   3 Value   5 |
> ath: PDADC (0,   0): a284 07070606
> ath: PDADC: Chain 0 | PDADC   4 Value   6 | PDADC   5 Value   6 | PDADC   6 Value   7 | PDADC   7 Value   7 |
> ath: PDADC (0,   0): a288 0a090808
> ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   8 | PDADC  10 Value   9 | PDADC  11 Value  10 |
> ath: PDADC (0,   0): a28c 0d0d0c0b
> ath: PDADC: Chain 0 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  13 |
> ath: PDADC (0,   0): a290 1312100f
> ath: PDADC: Chain 0 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  18 | PDADC  19 Value  19 |
> ath: PDADC (0,   0): a294 201c1815
> ath: PDADC: Chain 0 | PDADC  20 Value  21 | PDADC  21 Value  24 | PDADC  22 Value  28 | PDADC  23 Value  32 |
> ath: PDADC (0,   0): a298 302c2824
> ath: PDADC: Chain 0 | PDADC  24 Value  36 | PDADC  25 Value  40 | PDADC  26 Value  44 | PDADC  27 Value  48 |
> ath: PDADC (0,   0): a29c 413b3733
> ath: PDADC: Chain 0 | PDADC  28 Value  51 | PDADC  29 Value  55 | PDADC  30 Value  59 | PDADC  31 Value  65 |
> ath: PDADC (0,   0): a2a0 59534d47
> ath: PDADC: Chain 0 | PDADC  32 Value  71 | PDADC  33 Value  77 | PDADC  34 Value  83 | PDADC  35 Value  89 |
> ath: PDADC (0,   0): a2a4 726c665f
> ath: PDADC: Chain 0 | PDADC  36 Value  95 | PDADC  37 Value 102 | PDADC  38 Value 108 | PDADC  39 Value 114 |
> ath: PDADC (0,   0): a2a8 8a847e78
> ath: PDADC: Chain 0 | PDADC  40 Value 120 | PDADC  41 Value 126 | PDADC  42 Value 132 | PDADC  43 Value 138 |
> ath: PDADC (0,   0): a2ac 2b26211c
> ath: PDADC: Chain 0 | PDADC  44 Value  28 | PDADC  45 Value  33 | PDADC  46 Value  38 | PDADC  47 Value  43 |
> ath: PDADC (0,   0): a2b0 3e393530
> ath: PDADC: Chain 0 | PDADC  48 Value  48 | PDADC  49 Value  53 | PDADC  50 Value  57 | PDADC  51 Value  62 |
> ath: PDADC (0,   0): a2b4 534d4842
> ath: PDADC: Chain 0 | PDADC  52 Value  66 | PDADC  53 Value  72 | PDADC  54 Value  77 | PDADC  55 Value  83 |
> ath: PDADC (0,   0): a2b8 6c645e59
> ath: PDADC: Chain 0 | PDADC  56 Value  89 | PDADC  57 Value  94 | PDADC  58 Value 100 | PDADC  59 Value 108 |
> ath: PDADC (0,   0): a2bc 8f877e75
> ath: PDADC: Chain 0 | PDADC  60 Value 117 | PDADC  61 Value 126 | PDADC  62 Value 135 | PDADC  63 Value 143 |
> ath: PDADC (0,   0): a2c0 b6aca298
> ath: PDADC: Chain 0 | PDADC  64 Value 152 | PDADC  65 Value 162 | PDADC  66 Value 172 | PDADC  67 Value 182 |
> ath: PDADC (0,   0): a2c4 ded4cac0
> ath: PDADC: Chain 0 | PDADC  68 Value 192 | PDADC  69 Value 202 | PDADC  70 Value 212 | PDADC  71 Value 222 |
> ath: PDADC (0,   0): a2c8 dededede
> ath: PDADC: Chain 0 | PDADC  72 Value 222 | PDADC  73 Value 222 | PDADC  74 Value 222 | PDADC  75 Value 222 |
> ath: PDADC (0,   0): a2cc dededede
> ath: PDADC: Chain 0 | PDADC  76 Value 222 | PDADC  77 Value 222 | PDADC  78 Value 222 | PDADC  79 Value 222 |
> ath: PDADC (0,   0): a2d0 dededede
> ath: PDADC: Chain 0 | PDADC  80 Value 222 | PDADC  81 Value 222 | PDADC  82 Value 222 | PDADC  83 Value 222 |
> ath: PDADC (0,   0): a2d4 dededede
> ath: PDADC: Chain 0 | PDADC  84 Value 222 | PDADC  85 Value 222 | PDADC  86 Value 222 | PDADC  87 Value 222 |
> ath: PDADC (0,   0): a2d8 dededede
> ath: PDADC: Chain 0 | PDADC  88 Value 222 | PDADC  89 Value 222 | PDADC  90 Value 222 | PDADC  91 Value 222 |
> ath: PDADC (0,   0): a2dc dededede
> ath: PDADC: Chain 0 | PDADC  92 Value 222 | PDADC  93 Value 222 | PDADC  94 Value 222 | PDADC  95 Value 222 |
> ath: PDADC (0,   0): a2e0 dededede
> ath: PDADC: Chain 0 | PDADC  96 Value 222 | PDADC  97 Value 222 | PDADC  98 Value 222 | PDADC  99 Value 222 |
> ath: PDADC (0,   0): a2e4 dededede
> ath: PDADC: Chain 0 | PDADC 100 Value 222 | PDADC 101 Value 222 | PDADC 102 Value 222 | PDADC 103 Value 222 |
> ath: PDADC (0,   0): a2e8 dededede
> ath: PDADC: Chain 0 | PDADC 104 Value 222 | PDADC 105 Value 222 | PDADC 106 Value 222 | PDADC 107 Value 222 |
> ath: PDADC (0,   0): a2ec dededede
> ath: PDADC: Chain 0 | PDADC 108 Value 222 | PDADC 109 Value 222 | PDADC 110 Value 222 | PDADC 111 Value 222 |
> ath: PDADC (0,   0): a2f0 dededede
> ath: PDADC: Chain 0 | PDADC 112 Value 222 | PDADC 113 Value 222 | PDADC 114 Value 222 | PDADC 115 Value 222 |
> ath: PDADC (0,   0): a2f4 dededede
> ath: PDADC: Chain 0 | PDADC 116 Value 222 | PDADC 117 Value 222 | PDADC 118 Value 222 | PDADC 119 Value 222 |
> ath: PDADC (0,   0): a2f8 dededede
> ath: PDADC: Chain 0 | PDADC 120 Value 222 | PDADC 121 Value 222 | PDADC 122 Value 222 | PDADC 123 Value 222 |
> ath: PDADC (0,   0): a2fc dededede
> ath: PDADC: Chain 0 | PDADC 124 Value 222 | PDADC 125 Value 222 | PDADC 126 Value 222 | PDADC 127 Value 222 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2457 MHz
> ath: (2452 MHz) -> (2457 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 06050403
> ath: PDADC: Chain 0 | PDADC   0 Value   3 | PDADC   1 Value   4 | PDADC   2 Value   5 | PDADC   3 Value   6 |
> ath: PDADC (0,   0): a284 07070707
> ath: PDADC: Chain 0 | PDADC   4 Value   7 | PDADC   5 Value   7 | PDADC   6 Value   7 | PDADC   7 Value   7 |
> ath: PDADC (0,   0): a288 0a0a0908
> ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  10 |
> ath: PDADC (0,   0): a28c 0e0d0c0c
> ath: PDADC: Chain 0 | PDADC  12 Value  12 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
> ath: PDADC (0,   0): a290 14121110
> ath: PDADC: Chain 0 | PDADC  16 Value  16 | PDADC  17 Value  17 | PDADC  18 Value  18 | PDADC  19 Value  20 |
> ath: PDADC (0,   0): a294 211d1916
> ath: PDADC: Chain 0 | PDADC  20 Value  22 | PDADC  21 Value  25 | PDADC  22 Value  29 | PDADC  23 Value  33 |
> ath: PDADC (0,   0): a298 302c2824
> ath: PDADC: Chain 0 | PDADC  24 Value  36 | PDADC  25 Value  40 | PDADC  26 Value  44 | PDADC  27 Value  48 |
> ath: PDADC (0,   0): a29c 423c3834
> ath: PDADC: Chain 0 | PDADC  28 Value  52 | PDADC  29 Value  56 | PDADC  30 Value  60 | PDADC  31 Value  66 |
> ath: PDADC (0,   0): a2a0 5a544e48
> ath: PDADC: Chain 0 | PDADC  32 Value  72 | PDADC  33 Value  78 | PDADC  34 Value  84 | PDADC  35 Value  90 |
> ath: PDADC (0,   0): a2a4 746d6660
> ath: PDADC: Chain 0 | PDADC  36 Value  96 | PDADC  37 Value 102 | PDADC  38 Value 109 | PDADC  39 Value 116 |
> ath: PDADC (0,   0): a2a8 9089827b
> ath: PDADC: Chain 0 | PDADC  40 Value 123 | PDADC  41 Value 130 | PDADC  42 Value 137 | PDADC  43 Value 144 |
> ath: PDADC (0,   0): a2ac 2c27221d
> ath: PDADC: Chain 0 | PDADC  44 Value  29 | PDADC  45 Value  34 | PDADC  46 Value  39 | PDADC  47 Value  44 |
> ath: PDADC (0,   0): a2b0 3f3a3631
> ath: PDADC: Chain 0 | PDADC  48 Value  49 | PDADC  49 Value  54 | PDADC  50 Value  58 | PDADC  51 Value  63 |
> ath: PDADC (0,   0): a2b4 554f4944
> ath: PDADC: Chain 0 | PDADC  52 Value  68 | PDADC  53 Value  73 | PDADC  54 Value  79 | PDADC  55 Value  85 |
> ath: PDADC (0,   0): a2b8 6e66605b
> ath: PDADC: Chain 0 | PDADC  56 Value  91 | PDADC  57 Value  96 | PDADC  58 Value 102 | PDADC  59 Value 110 |
> ath: PDADC (0,   0): a2bc 938a8077
> ath: PDADC: Chain 0 | PDADC  60 Value 119 | PDADC  61 Value 128 | PDADC  62 Value 138 | PDADC  63 Value 147 |
> ath: PDADC (0,   0): a2c0 b7aea59c
> ath: PDADC: Chain 0 | PDADC  64 Value 156 | PDADC  65 Value 165 | PDADC  66 Value 174 | PDADC  67 Value 183 |
> ath: PDADC (0,   0): a2c4 dbd2c9c0
> ath: PDADC: Chain 0 | PDADC  68 Value 192 | PDADC  69 Value 201 | PDADC  70 Value 210 | PDADC  71 Value 219 |
> ath: PDADC (0,   0): a2c8 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC  72 Value 219 | PDADC  73 Value 219 | PDADC  74 Value 219 | PDADC  75 Value 219 |
> ath: PDADC (0,   0): a2cc dbdbdbdb
> ath: PDADC: Chain 0 | PDADC  76 Value 219 | PDADC  77 Value 219 | PDADC  78 Value 219 | PDADC  79 Value 219 |
> ath: PDADC (0,   0): a2d0 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC  80 Value 219 | PDADC  81 Value 219 | PDADC  82 Value 219 | PDADC  83 Value 219 |
> ath: PDADC (0,   0): a2d4 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC  84 Value 219 | PDADC  85 Value 219 | PDADC  86 Value 219 | PDADC  87 Value 219 |
> ath: PDADC (0,   0): a2d8 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC  88 Value 219 | PDADC  89 Value 219 | PDADC  90 Value 219 | PDADC  91 Value 219 |
> ath: PDADC (0,   0): a2dc dbdbdbdb
> ath: PDADC: Chain 0 | PDADC  92 Value 219 | PDADC  93 Value 219 | PDADC  94 Value 219 | PDADC  95 Value 219 |
> ath: PDADC (0,   0): a2e0 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC  96 Value 219 | PDADC  97 Value 219 | PDADC  98 Value 219 | PDADC  99 Value 219 |
> ath: PDADC (0,   0): a2e4 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC 100 Value 219 | PDADC 101 Value 219 | PDADC 102 Value 219 | PDADC 103 Value 219 |
> ath: PDADC (0,   0): a2e8 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC 104 Value 219 | PDADC 105 Value 219 | PDADC 106 Value 219 | PDADC 107 Value 219 |
> ath: PDADC (0,   0): a2ec dbdbdbdb
> ath: PDADC: Chain 0 | PDADC 108 Value 219 | PDADC 109 Value 219 | PDADC 110 Value 219 | PDADC 111 Value 219 |
> ath: PDADC (0,   0): a2f0 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC 112 Value 219 | PDADC 113 Value 219 | PDADC 114 Value 219 | PDADC 115 Value 219 |
> ath: PDADC (0,   0): a2f4 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC 116 Value 219 | PDADC 117 Value 219 | PDADC 118 Value 219 | PDADC 119 Value 219 |
> ath: PDADC (0,   0): a2f8 dbdbdbdb
> ath: PDADC: Chain 0 | PDADC 120 Value 219 | PDADC 121 Value 219 | PDADC 122 Value 219 | PDADC 123 Value 219 |
> ath: PDADC (0,   0): a2fc dbdbdbdb
> ath: PDADC: Chain 0 | PDADC 124 Value 219 | PDADC 125 Value 219 | PDADC 126 Value 219 | PDADC 127 Value 219 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2462 MHz
> ath: (2457 MHz) -> (2462 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 06050403
> ath: PDADC: Chain 0 | PDADC   0 Value   3 | PDADC   1 Value   4 | PDADC   2 Value   5 | PDADC   3 Value   6 |
> ath: PDADC (0,   0): a284 07070707
> ath: PDADC: Chain 0 | PDADC   4 Value   7 | PDADC   5 Value   7 | PDADC   6 Value   7 | PDADC   7 Value   7 |
> ath: PDADC (0,   0): a288 0b0a0908
> ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
> ath: PDADC (0,   0): a28c 0f0e0d0c
> ath: PDADC: Chain 0 | PDADC  12 Value  12 | PDADC  13 Value  13 | PDADC  14 Value  14 | PDADC  15 Value  15 |
> ath: PDADC (0,   0): a290 14131211
> ath: PDADC: Chain 0 | PDADC  16 Value  17 | PDADC  17 Value  18 | PDADC  18 Value  19 | PDADC  19 Value  20 |
> ath: PDADC (0,   0): a294 211d1916
> ath: PDADC: Chain 0 | PDADC  20 Value  22 | PDADC  21 Value  25 | PDADC  22 Value  29 | PDADC  23 Value  33 |
> ath: PDADC (0,   0): a298 312d2925
> ath: PDADC: Chain 0 | PDADC  24 Value  37 | PDADC  25 Value  41 | PDADC  26 Value  45 | PDADC  27 Value  49 |
> ath: PDADC (0,   0): a29c 433d3935
> ath: PDADC: Chain 0 | PDADC  28 Value  53 | PDADC  29 Value  57 | PDADC  30 Value  61 | PDADC  31 Value  67 |
> ath: PDADC (0,   0): a2a0 5b554f49
> ath: PDADC: Chain 0 | PDADC  32 Value  73 | PDADC  33 Value  79 | PDADC  34 Value  85 | PDADC  35 Value  91 |
> ath: PDADC (0,   0): a2a4 756e6761
> ath: PDADC: Chain 0 | PDADC  36 Value  97 | PDADC  37 Value 103 | PDADC  38 Value 110 | PDADC  39 Value 117 |
> ath: PDADC (0,   0): a2a8 918a837c
> ath: PDADC: Chain 0 | PDADC  40 Value 124 | PDADC  41 Value 131 | PDADC  42 Value 138 | PDADC  43 Value 145 |
> ath: PDADC (0,   0): a2ac 2d28231e
> ath: PDADC: Chain 0 | PDADC  44 Value  30 | PDADC  45 Value  35 | PDADC  46 Value  40 | PDADC  47 Value  45 |
> ath: PDADC (0,   0): a2b0 413b3732
> ath: PDADC: Chain 0 | PDADC  48 Value  50 | PDADC  49 Value  55 | PDADC  50 Value  59 | PDADC  51 Value  65 |
> ath: PDADC (0,   0): a2b4 57514b45
> ath: PDADC: Chain 0 | PDADC  52 Value  69 | PDADC  53 Value  75 | PDADC  54 Value  81 | PDADC  55 Value  87 |
> ath: PDADC (0,   0): a2b8 7068625d
> ath: PDADC: Chain 0 | PDADC  56 Value  93 | PDADC  57 Value  98 | PDADC  58 Value 104 | PDADC  59 Value 112 |
> ath: PDADC (0,   0): a2bc 968d837a
> ath: PDADC: Chain 0 | PDADC  60 Value 122 | PDADC  61 Value 131 | PDADC  62 Value 141 | PDADC  63 Value 150 |
> ath: PDADC (0,   0): a2c0 bdb3a99f
> ath: PDADC: Chain 0 | PDADC  64 Value 159 | PDADC  65 Value 169 | PDADC  66 Value 179 | PDADC  67 Value 189 |
> ath: PDADC (0,   0): a2c4 e5dbd1c7
> ath: PDADC: Chain 0 | PDADC  68 Value 199 | PDADC  69 Value 209 | PDADC  70 Value 219 | PDADC  71 Value 229 |
> ath: PDADC (0,   0): a2c8 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC  72 Value 229 | PDADC  73 Value 229 | PDADC  74 Value 229 | PDADC  75 Value 229 |
> ath: PDADC (0,   0): a2cc e5e5e5e5
> ath: PDADC: Chain 0 | PDADC  76 Value 229 | PDADC  77 Value 229 | PDADC  78 Value 229 | PDADC  79 Value 229 |
> ath: PDADC (0,   0): a2d0 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC  80 Value 229 | PDADC  81 Value 229 | PDADC  82 Value 229 | PDADC  83 Value 229 |
> ath: PDADC (0,   0): a2d4 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC  84 Value 229 | PDADC  85 Value 229 | PDADC  86 Value 229 | PDADC  87 Value 229 |
> ath: PDADC (0,   0): a2d8 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC  88 Value 229 | PDADC  89 Value 229 | PDADC  90 Value 229 | PDADC  91 Value 229 |
> ath: PDADC (0,   0): a2dc e5e5e5e5
> ath: PDADC: Chain 0 | PDADC  92 Value 229 | PDADC  93 Value 229 | PDADC  94 Value 229 | PDADC  95 Value 229 |
> ath: PDADC (0,   0): a2e0 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC  96 Value 229 | PDADC  97 Value 229 | PDADC  98 Value 229 | PDADC  99 Value 229 |
> ath: PDADC (0,   0): a2e4 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC 100 Value 229 | PDADC 101 Value 229 | PDADC 102 Value 229 | PDADC 103 Value 229 |
> ath: PDADC (0,   0): a2e8 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC 104 Value 229 | PDADC 105 Value 229 | PDADC 106 Value 229 | PDADC 107 Value 229 |
> ath: PDADC (0,   0): a2ec e5e5e5e5
> ath: PDADC: Chain 0 | PDADC 108 Value 229 | PDADC 109 Value 229 | PDADC 110 Value 229 | PDADC 111 Value 229 |
> ath: PDADC (0,   0): a2f0 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC 112 Value 229 | PDADC 113 Value 229 | PDADC 114 Value 229 | PDADC 115 Value 229 |
> ath: PDADC (0,   0): a2f4 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC 116 Value 229 | PDADC 117 Value 229 | PDADC 118 Value 229 | PDADC 119 Value 229 |
> ath: PDADC (0,   0): a2f8 e5e5e5e5
> ath: PDADC: Chain 0 | PDADC 120 Value 229 | PDADC 121 Value 229 | PDADC 122 Value 229 | PDADC 123 Value 229 |
> ath: PDADC (0,   0): a2fc e5e5e5e5
> ath: PDADC: Chain 0 | PDADC 124 Value 229 | PDADC 125 Value 229 | PDADC 126 Value 229 | PDADC 127 Value 229 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2467 MHz
> ath: (2462 MHz) -> (2467 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -118
> ath: PDADC (0,   0): a280 06050403
> ath: PDADC: Chain 0 | PDADC   0 Value   3 | PDADC   1 Value   4 | PDADC   2 Value   5 | PDADC   3 Value   6 |
> ath: PDADC (0,   0): a284 07070707
> ath: PDADC: Chain 0 | PDADC   4 Value   7 | PDADC   5 Value   7 | PDADC   6 Value   7 | PDADC   7 Value   7 |
> ath: PDADC (0,   0): a288 0b0a0908
> ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
> ath: PDADC (0,   0): a28c 100f0e0d
> ath: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  15 | PDADC  15 Value  16 |
> ath: PDADC (0,   0): a290 15141312
> ath: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  19 | PDADC  18 Value  20 | PDADC  19 Value  21 |
> ath: PDADC (0,   0): a294 221e1a17
> ath: PDADC: Chain 0 | PDADC  20 Value  23 | PDADC  21 Value  26 | PDADC  22 Value  30 | PDADC  23 Value  34 |
> ath: PDADC (0,   0): a298 322e2a26
> ath: PDADC: Chain 0 | PDADC  24 Value  38 | PDADC  25 Value  42 | PDADC  26 Value  46 | PDADC  27 Value  50 |
> ath: PDADC (0,   0): a29c 443e3a36
> ath: PDADC: Chain 0 | PDADC  28 Value  54 | PDADC  29 Value  58 | PDADC  30 Value  62 | PDADC  31 Value  68 |
> ath: PDADC (0,   0): a2a0 5c56504a
> ath: PDADC: Chain 0 | PDADC  32 Value  74 | PDADC  33 Value  80 | PDADC  34 Value  86 | PDADC  35 Value  92 |
> ath: PDADC (0,   0): a2a4 766f6862
> ath: PDADC: Chain 0 | PDADC  36 Value  98 | PDADC  37 Value 104 | PDADC  38 Value 111 | PDADC  39 Value 118 |
> ath: PDADC (0,   0): a2a8 928b847d
> ath: PDADC: Chain 0 | PDADC  40 Value 125 | PDADC  41 Value 132 | PDADC  42 Value 139 | PDADC  43 Value 146 |
> ath: PDADC (0,   0): a2ac 2e29241f
> ath: PDADC: Chain 0 | PDADC  44 Value  31 | PDADC  45 Value  36 | PDADC  46 Value  41 | PDADC  47 Value  46 |
> ath: PDADC (0,   0): a2b0 423c3833
> ath: PDADC: Chain 0 | PDADC  48 Value  51 | PDADC  49 Value  56 | PDADC  50 Value  60 | PDADC  51 Value  66 |
> ath: PDADC (0,   0): a2b4 59534d47
> ath: PDADC: Chain 0 | PDADC  52 Value  71 | PDADC  53 Value  77 | PDADC  54 Value  83 | PDADC  55 Value  89 |
> ath: PDADC (0,   0): a2b8 726a645f
> ath: PDADC: Chain 0 | PDADC  56 Value  95 | PDADC  57 Value 100 | PDADC  58 Value 106 | PDADC  59 Value 114 |
> ath: PDADC (0,   0): a2bc 9990867c
> ath: PDADC: Chain 0 | PDADC  60 Value 124 | PDADC  61 Value 134 | PDADC  62 Value 144 | PDADC  63 Value 153 |
> ath: PDADC (0,   0): a2c0 beb5aca3
> ath: PDADC: Chain 0 | PDADC  64 Value 163 | PDADC  65 Value 172 | PDADC  66 Value 181 | PDADC  67 Value 190 |
> ath: PDADC (0,   0): a2c4 e2d9d0c7
> ath: PDADC: Chain 0 | PDADC  68 Value 199 | PDADC  69 Value 208 | PDADC  70 Value 217 | PDADC  71 Value 226 |
> ath: PDADC (0,   0): a2c8 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC  72 Value 226 | PDADC  73 Value 226 | PDADC  74 Value 226 | PDADC  75 Value 226 |
> ath: PDADC (0,   0): a2cc e2e2e2e2
> ath: PDADC: Chain 0 | PDADC  76 Value 226 | PDADC  77 Value 226 | PDADC  78 Value 226 | PDADC  79 Value 226 |
> ath: PDADC (0,   0): a2d0 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC  80 Value 226 | PDADC  81 Value 226 | PDADC  82 Value 226 | PDADC  83 Value 226 |
> ath: PDADC (0,   0): a2d4 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC  84 Value 226 | PDADC  85 Value 226 | PDADC  86 Value 226 | PDADC  87 Value 226 |
> ath: PDADC (0,   0): a2d8 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC  88 Value 226 | PDADC  89 Value 226 | PDADC  90 Value 226 | PDADC  91 Value 226 |
> ath: PDADC (0,   0): a2dc e2e2e2e2
> ath: PDADC: Chain 0 | PDADC  92 Value 226 | PDADC  93 Value 226 | PDADC  94 Value 226 | PDADC  95 Value 226 |
> ath: PDADC (0,   0): a2e0 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC  96 Value 226 | PDADC  97 Value 226 | PDADC  98 Value 226 | PDADC  99 Value 226 |
> ath: PDADC (0,   0): a2e4 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC 100 Value 226 | PDADC 101 Value 226 | PDADC 102 Value 226 | PDADC 103 Value 226 |
> ath: PDADC (0,   0): a2e8 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC 104 Value 226 | PDADC 105 Value 226 | PDADC 106 Value 226 | PDADC 107 Value 226 |
> ath: PDADC (0,   0): a2ec e2e2e2e2
> ath: PDADC: Chain 0 | PDADC 108 Value 226 | PDADC 109 Value 226 | PDADC 110 Value 226 | PDADC 111 Value 226 |
> ath: PDADC (0,   0): a2f0 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC 112 Value 226 | PDADC 113 Value 226 | PDADC 114 Value 226 | PDADC 115 Value 226 |
> ath: PDADC (0,   0): a2f4 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC 116 Value 226 | PDADC 117 Value 226 | PDADC 118 Value 226 | PDADC 119 Value 226 |
> ath: PDADC (0,   0): a2f8 e2e2e2e2
> ath: PDADC: Chain 0 | PDADC 120 Value 226 | PDADC 121 Value 226 | PDADC 122 Value 226 | PDADC 123 Value 226 |
> ath: PDADC (0,   0): a2fc e2e2e2e2
> ath: PDADC: Chain 0 | PDADC 124 Value 226 | PDADC 125 Value 226 | PDADC 126 Value 226 | PDADC 127 Value 226 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2472 MHz
> ath: (2467 MHz) -> (2472 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -118
> ath: PDADC (0,   0): a280 08080706
> ath: PDADC: Chain 0 | PDADC   0 Value   6 | PDADC   1 Value   7 | PDADC   2 Value   8 | PDADC   3 Value   8 |
> ath: PDADC (0,   0): a284 08080808
> ath: PDADC: Chain 0 | PDADC   4 Value   8 | PDADC   5 Value   8 | PDADC   6 Value   8 | PDADC   7 Value   8 |
> ath: PDADC (0,   0): a288 0d0c0a09
> ath: PDADC: Chain 0 | PDADC   8 Value   9 | PDADC   9 Value  10 | PDADC  10 Value  12 | PDADC  11 Value  13 |
> ath: PDADC (0,   0): a28c 12110f0e
> ath: PDADC: Chain 0 | PDADC  12 Value  14 | PDADC  13 Value  15 | PDADC  14 Value  17 | PDADC  15 Value  18 |
> ath: PDADC (0,   0): a290 17161413
> ath: PDADC: Chain 0 | PDADC  16 Value  19 | PDADC  17 Value  20 | PDADC  18 Value  22 | PDADC  19 Value  23 |
> ath: PDADC (0,   0): a294 25211d19
> ath: PDADC: Chain 0 | PDADC  20 Value  25 | PDADC  21 Value  29 | PDADC  22 Value  33 | PDADC  23 Value  37 |
> ath: PDADC (0,   0): a298 35312d29
> ath: PDADC: Chain 0 | PDADC  24 Value  41 | PDADC  25 Value  45 | PDADC  26 Value  49 | PDADC  27 Value  53 |
> ath: PDADC (0,   0): a29c 48423d39
> ath: PDADC: Chain 0 | PDADC  28 Value  57 | PDADC  29 Value  61 | PDADC  30 Value  66 | PDADC  31 Value  72 |
> ath: PDADC (0,   0): a2a0 605a544e
> ath: PDADC: Chain 0 | PDADC  32 Value  78 | PDADC  33 Value  84 | PDADC  34 Value  90 | PDADC  35 Value  96 |
> ath: PDADC (0,   0): a2a4 78726c66
> ath: PDADC: Chain 0 | PDADC  36 Value 102 | PDADC  37 Value 108 | PDADC  38 Value 114 | PDADC  39 Value 120 |
> ath: PDADC (0,   0): a2a8 908a847e
> ath: PDADC: Chain 0 | PDADC  40 Value 126 | PDADC  41 Value 132 | PDADC  42 Value 138 | PDADC  43 Value 144 |
> ath: PDADC (0,   0): a2ac 2f2a2520
> ath: PDADC: Chain 0 | PDADC  44 Value  32 | PDADC  45 Value  37 | PDADC  46 Value  42 | PDADC  47 Value  47 |
> ath: PDADC (0,   0): a2b0 443e3934
> ath: PDADC: Chain 0 | PDADC  48 Value  52 | PDADC  49 Value  57 | PDADC  50 Value  62 | PDADC  51 Value  68 |
> ath: PDADC (0,   0): a2b4 5b554f49
> ath: PDADC: Chain 0 | PDADC  52 Value  73 | PDADC  53 Value  79 | PDADC  54 Value  85 | PDADC  55 Value  91 |
> ath: PDADC (0,   0): a2b8 756d6761
> ath: PDADC: Chain 0 | PDADC  56 Value  97 | PDADC  57 Value 103 | PDADC  58 Value 109 | PDADC  59 Value 117 |
> ath: PDADC (0,   0): a2bc 9d93897f
> ath: PDADC: Chain 0 | PDADC  60 Value 127 | PDADC  61 Value 137 | PDADC  62 Value 147 | PDADC  63 Value 157 |
> ath: PDADC (0,   0): a2c0 c2b9b0a7
> ath: PDADC: Chain 0 | PDADC  64 Value 167 | PDADC  65 Value 176 | PDADC  66 Value 185 | PDADC  67 Value 194 |
> ath: PDADC (0,   0): a2c4 e6ddd4cb
> ath: PDADC: Chain 0 | PDADC  68 Value 203 | PDADC  69 Value 212 | PDADC  70 Value 221 | PDADC  71 Value 230 |
> ath: PDADC (0,   0): a2c8 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  72 Value 230 | PDADC  73 Value 230 | PDADC  74 Value 230 | PDADC  75 Value 230 |
> ath: PDADC (0,   0): a2cc e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  76 Value 230 | PDADC  77 Value 230 | PDADC  78 Value 230 | PDADC  79 Value 230 |
> ath: PDADC (0,   0): a2d0 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  80 Value 230 | PDADC  81 Value 230 | PDADC  82 Value 230 | PDADC  83 Value 230 |
> ath: PDADC (0,   0): a2d4 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  84 Value 230 | PDADC  85 Value 230 | PDADC  86 Value 230 | PDADC  87 Value 230 |
> ath: PDADC (0,   0): a2d8 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  88 Value 230 | PDADC  89 Value 230 | PDADC  90 Value 230 | PDADC  91 Value 230 |
> ath: PDADC (0,   0): a2dc e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  92 Value 230 | PDADC  93 Value 230 | PDADC  94 Value 230 | PDADC  95 Value 230 |
> ath: PDADC (0,   0): a2e0 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  96 Value 230 | PDADC  97 Value 230 | PDADC  98 Value 230 | PDADC  99 Value 230 |
> ath: PDADC (0,   0): a2e4 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 100 Value 230 | PDADC 101 Value 230 | PDADC 102 Value 230 | PDADC 103 Value 230 |
> ath: PDADC (0,   0): a2e8 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 104 Value 230 | PDADC 105 Value 230 | PDADC 106 Value 230 | PDADC 107 Value 230 |
> ath: PDADC (0,   0): a2ec e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 108 Value 230 | PDADC 109 Value 230 | PDADC 110 Value 230 | PDADC 111 Value 230 |
> ath: PDADC (0,   0): a2f0 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 112 Value 230 | PDADC 113 Value 230 | PDADC 114 Value 230 | PDADC 115 Value 230 |
> ath: PDADC (0,   0): a2f4 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 116 Value 230 | PDADC 117 Value 230 | PDADC 118 Value 230 | PDADC 119 Value 230 |
> ath: PDADC (0,   0): a2f8 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 120 Value 230 | PDADC 121 Value 230 | PDADC 122 Value 230 | PDADC 123 Value 230 |
> ath: PDADC (0,   0): a2fc e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 124 Value 230 | PDADC 125 Value 230 | PDADC 126 Value 230 | PDADC 127 Value 230 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2484 MHz
> ath: (2472 MHz) -> (2484 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -118
> ath: PDADC (0,   0): a280 08080706
> ath: PDADC: Chain 0 | PDADC   0 Value   6 | PDADC   1 Value   7 | PDADC   2 Value   8 | PDADC   3 Value   8 |
> ath: PDADC (0,   0): a284 08080808
> ath: PDADC: Chain 0 | PDADC   4 Value   8 | PDADC   5 Value   8 | PDADC   6 Value   8 | PDADC   7 Value   8 |
> ath: PDADC (0,   0): a288 0d0c0a09
> ath: PDADC: Chain 0 | PDADC   8 Value   9 | PDADC   9 Value  10 | PDADC  10 Value  12 | PDADC  11 Value  13 |
> ath: PDADC (0,   0): a28c 12110f0e
> ath: PDADC: Chain 0 | PDADC  12 Value  14 | PDADC  13 Value  15 | PDADC  14 Value  17 | PDADC  15 Value  18 |
> ath: PDADC (0,   0): a290 17161413
> ath: PDADC: Chain 0 | PDADC  16 Value  19 | PDADC  17 Value  20 | PDADC  18 Value  22 | PDADC  19 Value  23 |
> ath: PDADC (0,   0): a294 25211d19
> ath: PDADC: Chain 0 | PDADC  20 Value  25 | PDADC  21 Value  29 | PDADC  22 Value  33 | PDADC  23 Value  37 |
> ath: PDADC (0,   0): a298 35312d29
> ath: PDADC: Chain 0 | PDADC  24 Value  41 | PDADC  25 Value  45 | PDADC  26 Value  49 | PDADC  27 Value  53 |
> ath: PDADC (0,   0): a29c 48423d39
> ath: PDADC: Chain 0 | PDADC  28 Value  57 | PDADC  29 Value  61 | PDADC  30 Value  66 | PDADC  31 Value  72 |
> ath: PDADC (0,   0): a2a0 605a544e
> ath: PDADC: Chain 0 | PDADC  32 Value  78 | PDADC  33 Value  84 | PDADC  34 Value  90 | PDADC  35 Value  96 |
> ath: PDADC (0,   0): a2a4 78726c66
> ath: PDADC: Chain 0 | PDADC  36 Value 102 | PDADC  37 Value 108 | PDADC  38 Value 114 | PDADC  39 Value 120 |
> ath: PDADC (0,   0): a2a8 908a847e
> ath: PDADC: Chain 0 | PDADC  40 Value 126 | PDADC  41 Value 132 | PDADC  42 Value 138 | PDADC  43 Value 144 |
> ath: PDADC (0,   0): a2ac 2f2a2520
> ath: PDADC: Chain 0 | PDADC  44 Value  32 | PDADC  45 Value  37 | PDADC  46 Value  42 | PDADC  47 Value  47 |
> ath: PDADC (0,   0): a2b0 443e3934
> ath: PDADC: Chain 0 | PDADC  48 Value  52 | PDADC  49 Value  57 | PDADC  50 Value  62 | PDADC  51 Value  68 |
> ath: PDADC (0,   0): a2b4 5b554f49
> ath: PDADC: Chain 0 | PDADC  52 Value  73 | PDADC  53 Value  79 | PDADC  54 Value  85 | PDADC  55 Value  91 |
> ath: PDADC (0,   0): a2b8 756d6761
> ath: PDADC: Chain 0 | PDADC  56 Value  97 | PDADC  57 Value 103 | PDADC  58 Value 109 | PDADC  59 Value 117 |
> ath: PDADC (0,   0): a2bc 9d93897f
> ath: PDADC: Chain 0 | PDADC  60 Value 127 | PDADC  61 Value 137 | PDADC  62 Value 147 | PDADC  63 Value 157 |
> ath: PDADC (0,   0): a2c0 c2b9b0a7
> ath: PDADC: Chain 0 | PDADC  64 Value 167 | PDADC  65 Value 176 | PDADC  66 Value 185 | PDADC  67 Value 194 |
> ath: PDADC (0,   0): a2c4 e6ddd4cb
> ath: PDADC: Chain 0 | PDADC  68 Value 203 | PDADC  69 Value 212 | PDADC  70 Value 221 | PDADC  71 Value 230 |
> ath: PDADC (0,   0): a2c8 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  72 Value 230 | PDADC  73 Value 230 | PDADC  74 Value 230 | PDADC  75 Value 230 |
> ath: PDADC (0,   0): a2cc e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  76 Value 230 | PDADC  77 Value 230 | PDADC  78 Value 230 | PDADC  79 Value 230 |
> ath: PDADC (0,   0): a2d0 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  80 Value 230 | PDADC  81 Value 230 | PDADC  82 Value 230 | PDADC  83 Value 230 |
> ath: PDADC (0,   0): a2d4 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  84 Value 230 | PDADC  85 Value 230 | PDADC  86 Value 230 | PDADC  87 Value 230 |
> ath: PDADC (0,   0): a2d8 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  88 Value 230 | PDADC  89 Value 230 | PDADC  90 Value 230 | PDADC  91 Value 230 |
> ath: PDADC (0,   0): a2dc e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  92 Value 230 | PDADC  93 Value 230 | PDADC  94 Value 230 | PDADC  95 Value 230 |
> ath: PDADC (0,   0): a2e0 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC  96 Value 230 | PDADC  97 Value 230 | PDADC  98 Value 230 | PDADC  99 Value 230 |
> ath: PDADC (0,   0): a2e4 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 100 Value 230 | PDADC 101 Value 230 | PDADC 102 Value 230 | PDADC 103 Value 230 |
> ath: PDADC (0,   0): a2e8 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 104 Value 230 | PDADC 105 Value 230 | PDADC 106 Value 230 | PDADC 107 Value 230 |
> ath: PDADC (0,   0): a2ec e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 108 Value 230 | PDADC 109 Value 230 | PDADC 110 Value 230 | PDADC 111 Value 230 |
> ath: PDADC (0,   0): a2f0 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 112 Value 230 | PDADC 113 Value 230 | PDADC 114 Value 230 | PDADC 115 Value 230 |
> ath: PDADC (0,   0): a2f4 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 116 Value 230 | PDADC 117 Value 230 | PDADC 118 Value 230 | PDADC 119 Value 230 |
> ath: PDADC (0,   0): a2f8 e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 120 Value 230 | PDADC 121 Value 230 | PDADC 122 Value 230 | PDADC 123 Value 230 |
> ath: PDADC (0,   0): a2fc e6e6e6e6
> ath: PDADC: Chain 0 | PDADC 124 Value 230 | PDADC 125 Value 230 | PDADC 126 Value 230 | PDADC 127 Value 230 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set channel: 2412 MHz
> ath: (2484 MHz) -> (2412 MHz), HT: 0, HT40: 0 fastcc: 1
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -119
> ath: PDADC (0,   0): a280 05040302
> ath: PDADC: Chain 0 | PDADC   0 Value   2 | PDADC   1 Value   3 | PDADC   2 Value   4 | PDADC   3 Value   5 |
> ath: PDADC (0,   0): a284 09080706
> ath: PDADC: Chain 0 | PDADC   4 Value   6 | PDADC   5 Value   7 | PDADC   6 Value   8 | PDADC   7 Value   9 |
> ath: PDADC (0,   0): a288 0e0c0b0a
> ath: PDADC: Chain 0 | PDADC   8 Value  10 | PDADC   9 Value  11 | PDADC  10 Value  12 | PDADC  11 Value  14 |
> ath: PDADC (0,   0): a28c 1211100f
> ath: PDADC: Chain 0 | PDADC  12 Value  15 | PDADC  13 Value  16 | PDADC  14 Value  17 | PDADC  15 Value  18 |
> ath: PDADC (0,   0): a290 18161514
> ath: PDADC: Chain 0 | PDADC  16 Value  20 | PDADC  17 Value  21 | PDADC  18 Value  22 | PDADC  19 Value  24 |
> ath: PDADC (0,   0): a294 211d1b19
> ath: PDADC: Chain 0 | PDADC  20 Value  25 | PDADC  21 Value  27 | PDADC  22 Value  29 | PDADC  23 Value  33 |
> ath: PDADC (0,   0): a298 2f2c2824
> ath: PDADC: Chain 0 | PDADC  24 Value  36 | PDADC  25 Value  40 | PDADC  26 Value  44 | PDADC  27 Value  47 |
> ath: PDADC (0,   0): a29c 3f3a3633
> ath: PDADC: Chain 0 | PDADC  28 Value  51 | PDADC  29 Value  54 | PDADC  30 Value  58 | PDADC  31 Value  63 |
> ath: PDADC (0,   0): a2a0 5a534d46
> ath: PDADC: Chain 0 | PDADC  32 Value  70 | PDADC  33 Value  77 | PDADC  34 Value  83 | PDADC  35 Value  90 |
> ath: PDADC (0,   0): a2a4 766f6861
> ath: PDADC: Chain 0 | PDADC  36 Value  97 | PDADC  37 Value 104 | PDADC  38 Value 111 | PDADC  39 Value 118 |
> ath: PDADC (0,   0): a2a8 928b847d
> ath: PDADC: Chain 0 | PDADC  40 Value 125 | PDADC  41 Value 132 | PDADC  42 Value 139 | PDADC  43 Value 146 |
> ath: PDADC (0,   0): a2ac 302d2a99
> ath: PDADC: Chain 0 | PDADC  44 Value 153 | PDADC  45 Value  42 | PDADC  46 Value  45 | PDADC  47 Value  48 |
> ath: PDADC (0,   0): a2b0 3d393633
> ath: PDADC: Chain 0 | PDADC  48 Value  51 | PDADC  49 Value  54 | PDADC  50 Value  57 | PDADC  51 Value  61 |
> ath: PDADC (0,   0): a2b4 4e484440
> ath: PDADC: Chain 0 | PDADC  52 Value  64 | PDADC  53 Value  68 | PDADC  54 Value  72 | PDADC  55 Value  78 |
> ath: PDADC (0,   0): a2b8 66605a54
> ath: PDADC: Chain 0 | PDADC  56 Value  84 | PDADC  57 Value  90 | PDADC  58 Value  96 | PDADC  59 Value 102 |
> ath: PDADC (0,   0): a2bc 887f776e
> ath: PDADC: Chain 0 | PDADC  60 Value 110 | PDADC  61 Value 119 | PDADC  62 Value 127 | PDADC  63 Value 136 |
> ath: PDADC (0,   0): a2c0 a8a19991
> ath: PDADC: Chain 0 | PDADC  64 Value 145 | PDADC  65 Value 153 | PDADC  66 Value 161 | PDADC  67 Value 168 |
> ath: PDADC (0,   0): a2c4 c4bdb6af
> ath: PDADC: Chain 0 | PDADC  68 Value 175 | PDADC  69 Value 182 | PDADC  70 Value 189 | PDADC  71 Value 196 |
> ath: PDADC (0,   0): a2c8 d9d9d2cb
> ath: PDADC: Chain 0 | PDADC  72 Value 203 | PDADC  73 Value 210 | PDADC  74 Value 217 | PDADC  75 Value 217 |
> ath: PDADC (0,   0): a2cc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  76 Value 217 | PDADC  77 Value 217 | PDADC  78 Value 217 | PDADC  79 Value 217 |
> ath: PDADC (0,   0): a2d0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  80 Value 217 | PDADC  81 Value 217 | PDADC  82 Value 217 | PDADC  83 Value 217 |
> ath: PDADC (0,   0): a2d4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  84 Value 217 | PDADC  85 Value 217 | PDADC  86 Value 217 | PDADC  87 Value 217 |
> ath: PDADC (0,   0): a2d8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  88 Value 217 | PDADC  89 Value 217 | PDADC  90 Value 217 | PDADC  91 Value 217 |
> ath: PDADC (0,   0): a2dc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  92 Value 217 | PDADC  93 Value 217 | PDADC  94 Value 217 | PDADC  95 Value 217 |
> ath: PDADC (0,   0): a2e0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  96 Value 217 | PDADC  97 Value 217 | PDADC  98 Value 217 | PDADC  99 Value 217 |
> ath: PDADC (0,   0): a2e4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 100 Value 217 | PDADC 101 Value 217 | PDADC 102 Value 217 | PDADC 103 Value 217 |
> ath: PDADC (0,   0): a2e8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 104 Value 217 | PDADC 105 Value 217 | PDADC 106 Value 217 | PDADC 107 Value 217 |
> ath: PDADC (0,   0): a2ec d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 108 Value 217 | PDADC 109 Value 217 | PDADC 110 Value 217 | PDADC 111 Value 217 |
> ath: PDADC (0,   0): a2f0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 112 Value 217 | PDADC 113 Value 217 | PDADC 114 Value 217 | PDADC 115 Value 217 |
> ath: PDADC (0,   0): a2f4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 116 Value 217 | PDADC 117 Value 217 | PDADC 118 Value 217 | PDADC 119 Value 217 |
> ath: PDADC (0,   0): a2f8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 120 Value 217 | PDADC 121 Value 217 | PDADC 122 Value 217 | PDADC 123 Value 217 |
> ath: PDADC (0,   0): a2fc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 124 Value 217 | PDADC 125 Value 217 | PDADC 126 Value 217 | PDADC 127 Value 217 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Enable MIB counters
> ath: ANI parameters:
> ath: noiseImmunityLevel=0, spurImmunityLevel=7, ofdmWeakSigDetectOff=1
> ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=0
> ath: ofdmPhyErrCount=0, cckPhyErrCount=0
> 
> ath: Writing ofdmbase=12582412   cckbase=12582712
> ath: Set HW RX filter: 0x207
> ath: idle: disabling radio
> ath: Disable MIB counters
> ath: Disable MIB counters
> ath: NF calibrated [ctl] [chain 0] is -117
> ath: PDADC (0,   0): a280 05040302
> ath: PDADC: Chain 0 | PDADC   0 Value   2 | PDADC   1 Value   3 | PDADC   2 Value   4 | PDADC   3 Value   5 |
> ath: PDADC (0,   0): a284 09080706
> ath: PDADC: Chain 0 | PDADC   4 Value   6 | PDADC   5 Value   7 | PDADC   6 Value   8 | PDADC   7 Value   9 |
> ath: PDADC (0,   0): a288 0e0c0b0a
> ath: PDADC: Chain 0 | PDADC   8 Value  10 | PDADC   9 Value  11 | PDADC  10 Value  12 | PDADC  11 Value  14 |
> ath: PDADC (0,   0): a28c 1211100f
> ath: PDADC: Chain 0 | PDADC  12 Value  15 | PDADC  13 Value  16 | PDADC  14 Value  17 | PDADC  15 Value  18 |
> ath: PDADC (0,   0): a290 18161514
> ath: PDADC: Chain 0 | PDADC  16 Value  20 | PDADC  17 Value  21 | PDADC  18 Value  22 | PDADC  19 Value  24 |
> ath: PDADC (0,   0): a294 211d1b19
> ath: PDADC: Chain 0 | PDADC  20 Value  25 | PDADC  21 Value  27 | PDADC  22 Value  29 | PDADC  23 Value  33 |
> ath: PDADC (0,   0): a298 2f2c2824
> ath: PDADC: Chain 0 | PDADC  24 Value  36 | PDADC  25 Value  40 | PDADC  26 Value  44 | PDADC  27 Value  47 |
> ath: PDADC (0,   0): a29c 3f3a3633
> ath: PDADC: Chain 0 | PDADC  28 Value  51 | PDADC  29 Value  54 | PDADC  30 Value  58 | PDADC  31 Value  63 |
> ath: PDADC (0,   0): a2a0 5a534d46
> ath: PDADC: Chain 0 | PDADC  32 Value  70 | PDADC  33 Value  77 | PDADC  34 Value  83 | PDADC  35 Value  90 |
> ath: PDADC (0,   0): a2a4 766f6861
> ath: PDADC: Chain 0 | PDADC  36 Value  97 | PDADC  37 Value 104 | PDADC  38 Value 111 | PDADC  39 Value 118 |
> ath: PDADC (0,   0): a2a8 928b847d
> ath: PDADC: Chain 0 | PDADC  40 Value 125 | PDADC  41 Value 132 | PDADC  42 Value 139 | PDADC  43 Value 146 |
> ath: PDADC (0,   0): a2ac 302d2a99
> ath: PDADC: Chain 0 | PDADC  44 Value 153 | PDADC  45 Value  42 | PDADC  46 Value  45 | PDADC  47 Value  48 |
> ath: PDADC (0,   0): a2b0 3d393633
> ath: PDADC: Chain 0 | PDADC  48 Value  51 | PDADC  49 Value  54 | PDADC  50 Value  57 | PDADC  51 Value  61 |
> ath: PDADC (0,   0): a2b4 4e484440
> ath: PDADC: Chain 0 | PDADC  52 Value  64 | PDADC  53 Value  68 | PDADC  54 Value  72 | PDADC  55 Value  78 |
> ath: PDADC (0,   0): a2b8 66605a54
> ath: PDADC: Chain 0 | PDADC  56 Value  84 | PDADC  57 Value  90 | PDADC  58 Value  96 | PDADC  59 Value 102 |
> ath: PDADC (0,   0): a2bc 887f776e
> ath: PDADC: Chain 0 | PDADC  60 Value 110 | PDADC  61 Value 119 | PDADC  62 Value 127 | PDADC  63 Value 136 |
> ath: PDADC (0,   0): a2c0 a8a19991
> ath: PDADC: Chain 0 | PDADC  64 Value 145 | PDADC  65 Value 153 | PDADC  66 Value 161 | PDADC  67 Value 168 |
> ath: PDADC (0,   0): a2c4 c4bdb6af
> ath: PDADC: Chain 0 | PDADC  68 Value 175 | PDADC  69 Value 182 | PDADC  70 Value 189 | PDADC  71 Value 196 |
> ath: PDADC (0,   0): a2c8 d9d9d2cb
> ath: PDADC: Chain 0 | PDADC  72 Value 203 | PDADC  73 Value 210 | PDADC  74 Value 217 | PDADC  75 Value 217 |
> ath: PDADC (0,   0): a2cc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  76 Value 217 | PDADC  77 Value 217 | PDADC  78 Value 217 | PDADC  79 Value 217 |
> ath: PDADC (0,   0): a2d0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  80 Value 217 | PDADC  81 Value 217 | PDADC  82 Value 217 | PDADC  83 Value 217 |
> ath: PDADC (0,   0): a2d4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  84 Value 217 | PDADC  85 Value 217 | PDADC  86 Value 217 | PDADC  87 Value 217 |
> ath: PDADC (0,   0): a2d8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  88 Value 217 | PDADC  89 Value 217 | PDADC  90 Value 217 | PDADC  91 Value 217 |
> ath: PDADC (0,   0): a2dc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  92 Value 217 | PDADC  93 Value 217 | PDADC  94 Value 217 | PDADC  95 Value 217 |
> ath: PDADC (0,   0): a2e0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC  96 Value 217 | PDADC  97 Value 217 | PDADC  98 Value 217 | PDADC  99 Value 217 |
> ath: PDADC (0,   0): a2e4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 100 Value 217 | PDADC 101 Value 217 | PDADC 102 Value 217 | PDADC 103 Value 217 |
> ath: PDADC (0,   0): a2e8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 104 Value 217 | PDADC 105 Value 217 | PDADC 106 Value 217 | PDADC 107 Value 217 |
> ath: PDADC (0,   0): a2ec d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 108 Value 217 | PDADC 109 Value 217 | PDADC 110 Value 217 | PDADC 111 Value 217 |
> ath: PDADC (0,   0): a2f0 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 112 Value 217 | PDADC 113 Value 217 | PDADC 114 Value 217 | PDADC 115 Value 217 |
> ath: PDADC (0,   0): a2f4 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 116 Value 217 | PDADC 117 Value 217 | PDADC 118 Value 217 | PDADC 119 Value 217 |
> ath: PDADC (0,   0): a2f8 d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 120 Value 217 | PDADC 121 Value 217 | PDADC 122 Value 217 | PDADC 123 Value 217 |
> ath: PDADC (0,   0): a2fc d9d9d9d9
> ath: PDADC: Chain 0 | PDADC 124 Value 217 | PDADC 125 Value 217 | PDADC 126 Value 217 | PDADC 127 Value 217 |
> ath: Getting spur idx 0 is2Ghz. 1 val 8000
> ath: Getting spur idx 1 is2Ghz. 1 val 8000
> ath: Getting spur idx 2 is2Ghz. 1 val 8000
> ath: Getting spur idx 3 is2Ghz. 1 val 8000
> ath: Getting spur idx 4 is2Ghz. 1 val 8000
> ath: Reset TX queue: 0
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 1
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 2
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 3
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TXQ, inactive queue: 4
> ath: Reset TXQ, inactive queue: 5
> ath: Reset TXQ, inactive queue: 6
> ath: Reset TXQ, inactive queue: 7
> ath: Reset TX queue: 8
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: Reset TX queue: 9
> ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> ath: ah->misc_mode 0x4
> ath: enabling ADC Gain Calibration.
> ath: enabling ADC DC Calibration.
> ath: enabling IQ Calibration.
> ath: starting ADC Gain Calibration
> ath: AWAKE -> FULL-SLEEP
> 
> -/bin/sh-3.00# iwconfig
> lo        no wireless extensions.
> 
> eth0      no wireless extensions.
> 
> wlan0     IEEE 802.11bgn  ESSID:"SYSGO"  
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm   
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           
> -/bin/sh-3.00# 
