Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2BGANQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:13:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:54283 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab2BGANO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:13:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121684238"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "perex@perex.cz" <perex@perex.cz>,
        "Ralston, James D" <james.d.ralston@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH 1/6] hda_intel: Add Lynx Point HD Audio
 Controller DeviceIDs
Thread-Topic: [alsa-devel] [PATCH 1/6] hda_intel: Add Lynx Point HD Audio
 Controller DeviceIDs
Thread-Index: AQHM2i6+Xo5tJV2DbkS/GNVTnMZPn5Yby5cAgAACngCAFNe14A==
Date: Tue, 7 Feb 2012 00:13:10 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A37FB3863@ORSMSX101.amr.corp.intel.com>
References: <201201231624.31275.seth.heasley@intel.com>
	<4F1E7DC0.5060208@canonical.com> <s5h7h0h2znx.wl%tiwai@suse.de>
In-Reply-To: <s5h7h0h2znx.wl%tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > This patch adds the HD Audio DeviceIDs for the Intel Lynx Point PCH.
>>
>> Thanks. As we asked for oak trail: can you confirm you prefer DMA
>> Position buffers for detecting current playback/recording position,
>over
>> using the LPIB register?
>
>Yes, thanks for the notice.
>
>I guess this won't need it since it's the successor of PPT.
>But it's always good to check it for the new hardware, indeed.

I'm also in favor of not rocking the boat, but I'm curious what changing this would entail, and what would be the advantage or rationale for making the change?

-Seth
