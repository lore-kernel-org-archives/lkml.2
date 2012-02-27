Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2B0SBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:01:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34861 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2B0SBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:01:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of egrumbach@gmail.com designates 10.180.93.232 as permitted sender) smtp.mail=egrumbach@gmail.com; dkim=pass header.i=egrumbach@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120227083612.GA5648@gamma.logic.tuwien.ac.at>
References: <20120125002250.GA20431@gamma.logic.tuwien.ac.at>
	<CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
	<20120126003735.GA2346@gamma.logic.tuwien.ac.at>
	<CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
	<CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
	<20120126232555.GB16330@gamma.logic.tuwien.ac.at>
	<20120127015015.GA23291@gamma.logic.tuwien.ac.at>
	<CANUX_P3F58upbrw48AiMTV4DDZWsfveYp=mANAD9CQ2bPps0cA@mail.gmail.com>
	<20120222003747.GA9808@gamma.logic.tuwien.ac.at>
	<CAOJsxLHoX2WU7xJ8etXsz32B=QhOADvMzBYzsuBR2YXvv44PyA@mail.gmail.com>
	<CANUX_P1CN0Ud5ZO4AMcvMSUsrsEABRHkgy42Di45n96mB64Ynw@mail.gmail.com>
	<20120227083612.GA5648@gamma.logic.tuwien.ac.at>
Date: Mon, 27 Feb 2012 20:01:11 +0200
Message-ID: <CANUX_P2jtrByqAJTAZDu-+5Nx-cYFKiO8Hkhepg7rDbEmNwfJQ@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sorry for the silence, I wasn't at the university for a few days so
> I couldn't test.
>
> Now I did:
> kernel 3.3-rc5
>
> On Mi, 22 Feb 2012, Emmanuel Grumbach wrote:
>> From the log, I can see that we have a lot of "passive channel
>> failures". Can you try to disable 11n (module_parameter) ?
>> Please also try with debug=0xc0000000

So this doesn't seem to be related to my rework of the AMPDU logic....
Will keep you updated if I think about something.
