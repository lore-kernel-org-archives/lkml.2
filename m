Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab1CJJl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:41:27 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:33197 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1CJJlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:41:25 -0500
X-IronPort-AV: E=Sophos;i="4.62,295,1297054800"; 
   d="scan'208";a="30403373"
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Cliff Cai <cliffcai.sh@gmail.com>
CC: Mike Frysinger <vapier.adi@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Date: Thu, 10 Mar 2011 04:45:48 -0500
Subject: RE: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
 Analog Devices ADAU1701 SigmaDSP
Thread-Topic: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
 Analog Devices ADAU1701 SigmaDSP
Thread-Index: AcveQO+EQHUkXSrgT+23gY5vSaPOYgAxdTEg
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16649F4A546@NWD2CMBX1.ad.analog.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com>
 <20110309100055.GB6923@opensource.wolfsonmicro.com>
In-Reply-To: <20110309100055.GB6923@opensource.wolfsonmicro.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2A9fY4E032613



>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>Sent: 2011å¹´3æœˆ9æ—¥ 18:01
>To: Cliff Cai
>Cc: Mike Frysinger; Cai, Cliff; alsa-devel@alsa-project.org;
>linux-kernel@vger.kernel.org;
>device-drivers-devel@blackfin.uclinux.org;
>akpm@linux-foundation.org; lrg@slimlogic.co.uk
>Subject: Re: [alsa-devel] [Device-drivers-devel] [PATCH] Add
>driver for Analog Devices ADAU1701 SigmaDSP
>
>On Wed, Mar 09, 2011 at 03:25:05PM +0800, Cliff Cai wrote:
>> On Mon, Mar 7, 2011 at 8:29 PM, Mike Frysinger
><vapier.adi@gmail.com> wrote:
>
>> > i dont see the issue here.  the firmware is *optional* and
>does not
>> > impair basic audio output.  further, the firmware is fully
>> > written/compiled/maintained by the end customer, just like the
>> > application.  which means there is no "magic" here -- the end
>> > customer is the wizard.
>
>> it's a DSP,so firmware is not optional,actually there is default
>> internal program can be used if no external firmware is
>downloaded,of
>> cause, the internal program is only used to test analog audio
>> pass-through.
>
>If there is default firmware then even if it's not
>particularly useful the kernel should probably not *require*
>that additional firmware is provided during driver startup -
>the system may wish to wait until later in the boot to provide
>it, for example because it needs to mount media to get to the
>firmware or because it needs to do additional work to decide
>what firmware is required for the current system setup.

I'm afraid it's not the real use case,the test mode just for test,
In practice,people always want the DSP to run some algrithm at the beginning,
Although they may change it later.

Cliff
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
