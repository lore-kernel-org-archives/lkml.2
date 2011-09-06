Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab1IFUPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:15:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:30925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab1IFUPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="45609314"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Tue, 6 Sep 2011 13:15:46 -0700
Subject: RE: [PATCH 2/5] mce: mask out undefined bits from MCi_ADDR
Thread-Topic: [PATCH 2/5] mce: mask out undefined bits from MCi_ADDR
Thread-Index: AcxrrO7lTDsWvr9lSUmdhnKEH6vbCABJIRtA
Message-ID: <987664A83D2D224EAE907B061CE93D5301EA8F97DC@orsmsx505.amr.corp.intel.com>
References: <4e5eb4e821049d6d79@agluck-desktop.sc.intel.com>
 <4E64941B.2070708@linux.intel.com>
In-Reply-To: <4E64941B.2070708@linux.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id p86KFwqr016494

>> +		if (mce_ser&&  (m->status&  MCI_STATUS_MISCV)) {
>> +			u8 shift = m->misc&  0x1f;
>
> According to SDM, here it should be "m->misc & 0x3f"

Correct. You, or somebody pointed this out before ... and I managed to
drop the fix while merging & rebasing ... will try to get it applied
this time.

Thanks

-Tony

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
