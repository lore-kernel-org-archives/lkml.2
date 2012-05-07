Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab2EGTY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:24:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:6077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab2EGTYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:24:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="141085705"
From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>,
        "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: RE: [ 73/75] iwlwifi: use correct released ucode version
Thread-Topic: [ 73/75] iwlwifi: use correct released ucode version
Thread-Index: AQHNLF+UAK3Gku7Q8kWeCc8p19TzFpa+tRUg
Date: Mon, 7 May 2012 19:24:50 +0000
Message-ID: <4595B4D22AB93C4FABBA84AAD5AA37FD1531EC@ORSMSX103.amr.corp.intel.com>
References: <20120504204230.580609792@linuxfoundation.org>
 <1336401714.8274.320.camel@deadeye>
In-Reply-To: <1336401714.8274.320.camel@deadeye>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q47JP1Q6020725

Hi Ben,

>On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
>> 3.3-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
>>
>> commit 78cbcf2b9dbe0565820dc7721316f9c401000a68 upstream.
>>
>> Report correctly the latest released version of the iwlwifi firmware
>> for all iwlwifi-supported devices.
>[...]
>
>Isn't this also applicable to 3.2.y?

[MV] Just checked -- it is indeed applicable to 3.2 stable kernels as well.  Do I need to modify the patch to get it into 3.2 as well?

Thanks,
Meenakshi
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
