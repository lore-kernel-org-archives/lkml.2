Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2A0AGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:06:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35928 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab2A0AGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:06:38 -0500
MIME-Version: 1.0
In-Reply-To: <20120126232555.GB16330@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
	<CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
	<20120125002250.GA20431@gamma.logic.tuwien.ac.at>
	<CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
	<20120126003735.GA2346@gamma.logic.tuwien.ac.at>
	<CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
	<CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
	<20120126232555.GB16330@gamma.logic.tuwien.ac.at>
Date: Thu, 26 Jan 2012 16:06:36 -0800
Message-ID: <CANUX_P0z2800ip=yfW15zELqhDNFrHbTvDY3OF59PuxizN=XSA@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 15:25, Norbert Preining <preining@logic.at> wrote:
> Hi Emmanuel,
>
> On Do, 26 Jan 2012, Emmanuel Grumbach wrote:
>> are suffering from the same issue. I am merging the mail threads here.
>
> First tests are promising, after reboot it was working immediately
> without need to rfkill block/unblock. lso after suspend and resume.
>
> Will test more the next days and report back.
>
> dmesg output without debugging still the same, but connection
> continues without any problem:
> [   62.437916] Open BA session requested for 00:0a:79:eb:56:10 tid 0
> [   62.456184] activated addBA response timer on tid 0
> [   63.456042] addBA response timer expired on tid 0
> [   63.456063] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
> [   67.008297] switched off addBA timer for tid 0
> [   67.008305] got addBA resp for tid 0 but we already gave up
> [   67.008340] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
> [   67.015503] Open BA session requested for 00:0a:79:eb:56:10 tid 0
> [   67.031648] activated addBA response timer on tid 0
> [   67.129907] switched off addBA timer for tid 0
> [   67.129914] Aggregation is on for tid 0
> [   67.130076] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
> [  100.288018] tx session timer expired on tid 0
> [  100.288032] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
> [  106.347302] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
> [  106.374760] Open BA session requested for 00:0a:79:eb:56:10 tid 0
> [  106.388178] activated addBA response timer on tid 0
> [  106.390041] switched off addBA timer for tid 0
> [  106.390044] Aggregation is on for tid 0
> [  106.390193] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
> [  135.786765] Open BA session requested for 00:0a:79:eb:56:10 tid 6
> [  135.804164] activated addBA response timer on tid 6
> [  135.806088] switched off addBA timer for tid 6
> [  135.806092] Aggregation is on for tid 6
> [  135.806241] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 6
> [  146.912031] tx session timer expired on tid 6
> [  146.912071] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 6
> [  146.924187] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 6
> [  256.560100] tx session timer expired on tid 0
> [  256.560132] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
> [  256.584379] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
> [  258.477345] Open BA session requested for 00:0a:79:eb:56:10 tid 0
> [  258.500189] activated addBA response timer on tid 0
> [  258.502148] switched off addBA timer for tid 0
> [  258.502151] Aggregation is on for tid 0
> [  258.502340] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:0a:79:eb:56:10 tid = 0
>
> Later on after resume I got a few hickups but the connection just
> hang for a shor ttime, then came back:
> [  589.895086] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
> [  589.895095] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
> [  589.900879] Rx A-MPDU request on tid 0 result 0
> [  589.900950] unexpected AddBA Req from 00:0a:79:eb:56:10 on tid 0
> [  589.900958] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
> [  589.902649] Rx A-MPDU request on tid 0 result 0
> [  589.902690] unexpected AddBA Req from 00:0a:79:eb:56:10 on tid 0
> [  589.902698] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
> [  589.903732] Rx A-MPDU request on tid 0 result 0
> [  589.903810] unexpected AddBA Req from 00:0a:79:eb:56:10 on tid 0
> [  589.903817] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
> [  589.904965] Rx A-MPDU request on tid 0 result 0
> [  589.905045] unexpected AddBA Req from 00:0a:79:eb:56:10 on tid 0
> [  589.905053] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 recipient reason: 32
> [  589.906510] Rx A-MPDU request on tid 0 result 0
> [  590.456062] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
> [  590.456075] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
> [  590.456083] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
> [  594.413810] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
> [  594.413822] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
> [  594.428073] Rx A-MPDU request on tid 0 result 0
>
>
> Generally fine.
>
> Thanks, more reports later.
>

Dave ?
