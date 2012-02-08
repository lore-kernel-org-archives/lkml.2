Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab2BHAfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:35:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:49081 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab2BHAfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:35:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="64243020"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: David Henningsson <david.henningsson@canonical.com>
CC: Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "perex@perex.cz" <perex@perex.cz>,
        "Ralston, James D" <james.d.ralston@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH 1/6] hda_intel: Add Lynx Point HD Audio
 Controller DeviceIDs
Thread-Topic: [alsa-devel] [PATCH 1/6] hda_intel: Add Lynx Point HD Audio
 Controller DeviceIDs
Thread-Index: AQHM2i6+Xo5tJV2DbkS/GNVTnMZPn5Yby5cAgAACngCAFNe14IAA1AMAgADEgjA=
Date: Wed, 8 Feb 2012 00:35:33 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A37FB7D68@ORSMSX101.amr.corp.intel.com>
References: <201201231624.31275.seth.heasley@intel.com>
 <4F1E7DC0.5060208@canonical.com> <s5h7h0h2znx.wl%tiwai@suse.de>
 <DEC3922D1904474A8862C7BFF516EA9A37FB3863@ORSMSX101.amr.corp.intel.com>
 <4F30ADB6.1000109@canonical.com>
In-Reply-To: <4F30ADB6.1000109@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm also in favor of not rocking the boat, but I'm curious what
>changing this would entail, and what would be the advantage or rationale
>for making the change?
>
>Reading the LPIB register, and reading the DMA position buffer, are two
>different methods of reading the current playback (or recording)
>position, i e which sample is currently being played back.
>
>The problem is that some chipsets prefer one method over the other, i e,
>only one of the methods work reliably. And if the other method only
>breaks occasionally, this can be quite difficult to detect and track
>down - we will have users complaining about their audio sometimes either
>sounding distorted, maybe not working at all, or just once in a while
>glitches. All of these symptoms can have many causes, so deducing that
>to a broken playback position is time consuming. That's why I think it's
>worth the extra question, to get it right from the start.
>
>So...thanks in advance for looking it up for us? :-)

I'm inquiring about it, but I can say that it seems to work just fine using the DMA position buffer.

-Seth


