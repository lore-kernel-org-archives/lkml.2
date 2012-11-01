Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992645Ab2KAXr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:47:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:59699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992551Ab2KAXrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:47:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="214202699"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Thread-Topic: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Thread-Index: AQHNuCDOuRD+LyTnWU633Vkrr6zwkZfVUmSAgACISoD//5ZoIIAAjUSA//+mO7A=
Date: Thu, 1 Nov 2012 23:47:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5C22B@ORSMSX108.amr.corp.intel.com>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
 <20121101110512.GA31271@liondog.tnic> <20121101094721.2a57719c@redhat.com>
 <20121101195509.GE31271@liondog.tnic>
 <3908561D78D1C84285E8C5FCA982C28F19D5C13C@ORSMSX108.amr.corp.intel.com>
 <20121101220249.GI31271@liondog.tnic>
In-Reply-To: <20121101220249.GI31271@liondog.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA1Nm9fq027416

> Right, but at least in the csrow case, we still can compute back the
> csrow even with the interleaving, after we know how it is done exactly
> (on which address bits, etc). I think this should be doable on Intel
> controllers too but I don't know.

No. Architecturally all Intel provides is the physical address in MCi_ADDR.
To do anything with that you are into per-system space, and the
registers that define the mappings are not necessarily available
to OS code ... sometimes they are, and sometimes they are even
documented in places where Mauro can use them to write an
EDAC driver ... but there are no guarantees.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
