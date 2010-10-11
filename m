Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0JKHd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:33:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:47356 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0JKHd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:33:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,312,1283756400"; 
   d="scan'208";a="615429362"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Date: Mon, 11 Oct 2010 08:32:28 +0100
Subject: RE: [Bug #16462] unable to connect to hidden SSID AP on legal
 channel 13
Thread-Topic: [Bug #16462] unable to connect to hidden SSID AP on legal
 channel 13
Thread-Index: ActosG9P5gkx88qjROSuMcouiGSrFAAZgBBA
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D3D355C4@irsmsx504.ger.corp.intel.com>
References: <pyPtebg28EI.A.ZPH.NvgsMB@chimera>
 <yeAD7A8RDxC.A.xu.dxgsMB@chimera>
In-Reply-To: <yeAD7A8RDxC.A.xu.dxgsMB@chimera>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9B7Xjkj013869

Rafael,

I believe that we have fixed the part of this bug that was a regression, namely being unable to connect to a non-hidden SSID, in 2.6.35 commit 3ee378d7e0dfdb9bb. Being able to connect to a hidden SSID I believe isn't a regression, and a patch for that is on its way upstream for 2.6.37. I think you should stop tracking this as a regression.

johannes

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Sunday, October 10, 2010 9:19 PM
> To: Linux Kernel Mailing List
> Cc: Kernel Testers List; Maciej Rutecki; Florian Mickler; Daniel J
> Blueman; Berg, Johannes
> Subject: [Bug #16462] unable to connect to hidden SSID AP on legal
> channel 13
> 
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16462
> Subject		: unable to connect to hidden SSID AP on legal
> channel 13
> Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
> Date		: 2010-07-25 17:06 (78 days old)
> Handled-By	: Johannes Berg <johannes.berg@intel.com>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=31862
> 

--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
