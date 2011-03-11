Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1CKHuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:50:37 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:60376 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab1CKHug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:50:36 -0500
X-IronPort-AV: E=Sophos;i="4.62,302,1297054800"; 
   d="scan'208";a="30517186"
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Cliff Cai <cliffcai.sh@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Date: Fri, 11 Mar 2011 02:54:42 -0500
Subject: RE: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
 Analog Devices ADAU1701 SigmaDSP
Thread-Topic: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
 Analog Devices ADAU1701 SigmaDSP
Thread-Index: AcvfKZam6TZAvi5VQQOBD5X7APL8PQAltG4g
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16649F4A8FB@NWD2CMBX1.ad.analog.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com>
 <20110309100055.GB6923@opensource.wolfsonmicro.com>
 <DB904C5425BA6F4E8424B3B51A1414D16649F4A546@NWD2CMBX1.ad.analog.com>
 <20110310134605.GC22195@opensource.wolfsonmicro.com>
In-Reply-To: <20110310134605.GC22195@opensource.wolfsonmicro.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2B7os29006798



>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>Sent: 2011Äê3ÔÂ10ÈÕ 21:46
>To: Cai, Cliff
>Cc: Cliff Cai; Mike Frysinger; alsa-devel@alsa-project.org;
>linux-kernel@vger.kernel.org;
>device-drivers-devel@blackfin.uclinux.org;
>akpm@linux-foundation.org; lrg@slimlogic.co.uk
>Subject: Re: [alsa-devel] [Device-drivers-devel] [PATCH] Add
>driver for Analog Devices ADAU1701 SigmaDSP
>
>On Thu, Mar 10, 2011 at 04:45:48AM -0500, Cai, Cliff wrote:
>
>> >If there is default firmware then even if it's not particularly
>> >useful the kernel should probably not *require* that additional
>> >firmware is provided during driver startup -
>
>> I'm afraid it's not the real use case,the test mode just for
>test, In
>> practice,people always want the DSP to run some algrithm at the
>> beginning, Although they may change it later.
>
>I'd be surprised if people wanted to actually play audio
>through a passthrough firmware in a shipping system but
>consider cases like board bringup (where just verifying that
>everything is physically connected is
>useful) and early boot (where you might not have mounted all
>filesystems yet but the driver is trying to start up).

1.The default firmware is used when the chip is just powered-up,
Once driver gets the control,it should load the custom firmware to replace
The default one,
2.we don't need to worry about this case,the driver which needs loading firmware
Has to be compiled as a module,and of cause,we load it after the filesystem has been mounted.

Cliff
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
