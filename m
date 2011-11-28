Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1K1Gd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 01:33:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60056 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab1K1GdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 01:33:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111128042343.GA4619@gamma.logic.tuwien.ac.at>
References: <CANUX_P1zDDzMy5yrFXSZAkMQ-87uu-fE1e-2sCEgHJi4dh5eiw@mail.gmail.com>
	<20111125122143.GA30404@gamma.logic.tuwien.ac.at>
	<CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com>
	<20111125123720.GA31564@gamma.logic.tuwien.ac.at>
	<CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com>
	<CANUX_P1aAz-4TpgSzQ2G=RkJOxXCAVQBja3GNsj_HpMNmqxeUw@mail.gmail.com>
	<1322387175.4044.16.camel@jlt3.sipsolutions.net>
	<CANUX_P3uoNOj3j-REvYCZP382cHfq+DpBRi7fnzFfMG_dyHtTQ@mail.gmail.com>
	<20111128035627.GH1422@gamma.logic.tuwien.ac.at>
	<CANUX_P2kYiFCP8uAhLZC_kVEjoyxabRBx3Pn+ndtFus=6hJN7Q@mail.gmail.com>
	<20111128042343.GA4619@gamma.logic.tuwien.ac.at>
Date: Mon, 28 Nov 2011 08:33:23 +0200
Message-ID: <CANUX_P2GWdAvoqnFxMG9WnhAQww-Pn9JEEai_Hk6_yVazb_qJw@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 06:23, Norbert Preining <preining@logic.at> wrote:
> On Mo, 28 Nov 2011, Emmanuel Grumbach wrote:
>> If the problem is solved, then no :-)
>
> I will report back. I have now reverted all the patches and additions
> by stashing them away, and applied only the last patch send. THe only
> thing out of default I see is:
> [ 1074.038324] wlan0: associated
> [ 1076.157989] Rx A-MPDU request on tid 0 result 0
> [ 1098.215008] Open BA session requested for 00:24:c4:ab:bd:ef tid 0
> [ 1098.232249] activated addBA response timer on tid 0
> [ 1098.232861] switched off addBA timer for tid 0
> [ 1098.232868] Aggregation is on for tid 0
> [ 1098.233027] iwlwifi 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
> but it seems to work smoothly.
>
> I will report more after a few suspend/resume iteations.
>

Ok
It is a bit odd though since these prints seem to point to a
successful flow, while you were likely to experience a problem in the
handshake between the AP and your machine. I am basically saying that
this log is too good, you didn't get into the corner case that we
didn't handle properly.
