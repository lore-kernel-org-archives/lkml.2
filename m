Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0JRIcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:32:31 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27580 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab0JRIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:32:30 -0400
X-IronPort-AV: E=Sophos;i="4.57,345,1283745600"; 
   d="scan'208";a="23487740"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Mike Frysinger <vapier@gentoo.org>, Randy Dunlap <rdunlap@xenotime.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Oct 2010 09:32:21 +0100
Subject: RE: [PATCH] ad525x_dpot: default to off
Thread-Topic: [PATCH] ad525x_dpot: default to off
Thread-Index: ActuPhP6fPdwNmdaTzayTQy1spOwIwAXzQYQ
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713094520E55@LIMKCMBX1.ad.analog.com>
References: <1287296545-21822-1-git-send-email-vapier@gentoo.org>
 <20101017121953.40831b35.rdunlap@xenotime.net>
 <AANLkTim7iG0UuusoOvWU+V8PoOPeOK4MxV2cBR-u7vtG@mail.gmail.com>
In-Reply-To: <AANLkTim7iG0UuusoOvWU+V8PoOPeOK4MxV2cBR-u7vtG@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9I8Wrvu005442

Mike Frysinger wrote on 2010-10-17:
> On Sun, Oct 17, 2010 at 15:19, Randy Dunlap wrote:
>> On Sun, 17 Oct 2010 02:22:25 -0400 Mike Frysinger wrote:
>>> From: Michael Hennerich <michael.hennerich@analog.com>
>>>
>>> No reason for this to be enabled by default.
>>
>> The default is automatically 'n', so please explain (more) why this is
>> needed...?
>
> we were seeing it turned on automatically.  maybe Michael can find the
> reproduction testcase ...
> -mike

A while ago I saw this automatically being proposed to y in case
# CONFIG_AD525X_DPOT is not set
Was not present in the boards_defconfig.

Right now I tried to recreate the issue, but I wasn't able.
Please ignore this patch.

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
