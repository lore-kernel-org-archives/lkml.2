Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2JHSFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 14:05:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:46246 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab2JHSFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 14:05:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,555,1344236400"; 
   d="scan'208";a="232107463"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mike Bakhterev <mike.bakhterev@gmail.com>,
        Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: boot failure on i7-3317u in Samsung 900x3c
Thread-Topic: boot failure on i7-3317u in Samsung 900x3c
Thread-Index: AQHNpT0OFhN6Zra9x0WndAgs3yXilpev+uuAgAAYmYCAABIaAP//jbIg
Date: Mon, 8 Oct 2012 18:05:13 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D49494@ORSMSX108.amr.corp.intel.com>
References: <CACx33gg6Hmh8E0Mv5TLdi5ufZcppHMws8XAdfaThF_Y2QBb5vA@mail.gmail.com>
	<1349690974.15966.113.camel@mfleming-mobl1.ger.corp.intel.com>
	<CACx33ghsnYz0VNwEbhuyn7ZgrtamHfrTKHR4E0b9Q+LpahcDXw@mail.gmail.com>
	<1349714729.15966.167.camel@mfleming-mobl1.ger.corp.intel.com>
 <CACx33gg7M7WNFrFg47WX17HZvD-H6mW8_w5y8d16K-uMfUa_kQ@mail.gmail.com>
In-Reply-To: <CACx33gg7M7WNFrFg47WX17HZvD-H6mW8_w5y8d16K-uMfUa_kQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q98I5enF032744

> STATUS be2000000003110a MCGSTATUS 5

The SDM can help here. See volume 3A, section 15.9.2 "Compound Error Codes".

The low 16 bits of the status in this case are 0001 0001 0000 1010

This tells us that you have a cache error in L2 cache severe enough that the
processor has begun filtering further error reports.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
