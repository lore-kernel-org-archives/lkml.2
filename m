Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1CNCSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 22:18:55 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:9778 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1CNCSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 22:18:53 -0400
X-IronPort-AV: E=Sophos;i="4.62,313,1297054800"; 
   d="scan'208";a="30217858"
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Cliff Cai <cliffcai.sh@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Date: Sun, 13 Mar 2011 22:23:19 -0400
Subject: RE: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
 Analog Devices ADAU1701 SigmaDSP
Thread-Topic: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
 Analog Devices ADAU1701 SigmaDSP
Thread-Index: Acvf4v0OjS0pJ98bTSG+gUiYlu1ScQCCt3aw
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16649F4AB9D@NWD2CMBX1.ad.analog.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com>
 <20110309100055.GB6923@opensource.wolfsonmicro.com>
 <DB904C5425BA6F4E8424B3B51A1414D16649F4A546@NWD2CMBX1.ad.analog.com>
 <20110310134605.GC22195@opensource.wolfsonmicro.com>
 <DB904C5425BA6F4E8424B3B51A1414D16649F4A8FB@NWD2CMBX1.ad.analog.com>
 <20110311115344.GA1760@opensource.wolfsonmicro.com>
In-Reply-To: <20110311115344.GA1760@opensource.wolfsonmicro.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2E2JG6u020317



>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>Sent: 2011Äê3ÔÂ11ÈÕ 19:54
>To: Cai, Cliff
>Cc: Cliff Cai; Mike Frysinger; alsa-devel@alsa-project.org;
>linux-kernel@vger.kernel.org;
>device-drivers-devel@blackfin.uclinux.org;
>akpm@linux-foundation.org; lrg@slimlogic.co.uk
>Subject: Re: [alsa-devel] [Device-drivers-devel] [PATCH] Add
>driver for Analog Devices ADAU1701 SigmaDSP
>
>On Fri, Mar 11, 2011 at 02:54:42AM -0500, Cai, Cliff wrote:
>
>> 1.The default firmware is used when the chip is just
>powered-up, Once
>> driver gets the control,it should load the custom firmware
>to replace
>> The default one, 2.we don't need to worry about this case,the driver
>> which needs loading firmware Has to be compiled as a module,and of
>> cause,we load it after the filesystem has been mounted.
>
>Forcing the driver to be build modular isn't great for
>usability either, though - it's not very general and some
>systems don't use modules at all for various reasons (eg,
>simplicity or difficulties in keeping the fs and the kernel
>partitions in sync).
>
>I'm not sure this gels well with the approach you're taking
>with the driver just passing the firmware through.  On the one
>hand you don't want the driver to know anything about the
>firmware or join up the firmware handling with the audio
>subsystem but on the other hand the driver is requiring that a
>firmware be loaded as soon as the driver is even though it can
>provide some very basic functionality without it.
>It'd seem better to just let the user load firmware at their leisure.
>

Hi Mark,

I think I need to have a check of the requirement from customer.
Anyway,if I modified the driver according to the comments here,
Would you like to accept it currently or we need to wait until the missing patch
Has been merged in mainline?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
