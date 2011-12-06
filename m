Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab1LFCM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 21:12:56 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:12062 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab1LFCMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 21:12:55 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK9371K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:141.131.3.20;KIP:(null);UIP:(null);IPV:NLI;H:mail1.cirrus.com;RD:mail1.cirrus.com;EFVD:NLI
From: "Austin, Brian" <Brian.Austin@cirrus.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mike Frysinger <vapier@gentoo.org>,
        "qi.wang@intel.com" <qi.wang@intel.com>, Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.y.wang@intel.com" <yong.y.wang@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>,
        Daniel Mack <zonque@gmail.com>, Liam Girdwood <lrg@ti.com>,
        "joel.clark@intel.com" <joel.clark@intel.com>
Subject: Re: [alsa-devel] [PATCH v2] soc/lapis: add machine driver
Thread-Topic: [alsa-devel] [PATCH v2] soc/lapis: add machine driver
Thread-Index: AQHMs3w6kfRt8JlU6U2rOqmxskGzHpXOc80A//+eT8A=
Date: Tue, 6 Dec 2011 02:11:40 +0000
Message-ID: <057C8CCF-453E-4DC2-8E22-3D260973D35E@cirrus.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
	<20111202153401.GX8245@opensource.wolfsonmicro.com>
	<CANKRQniyjT_2Ko=EYmffu3_NzDJQTMm9nY6rUp-DQ70e6AVQpA@mail.gmail.com>
	<20111205183223.GB7467@opensource.wolfsonmicro.com>,<CANKRQnhEFvubv0b63z34=_xn4x4q=20enofqPrMsFetj1x7-NQ@mail.gmail.com>
In-Reply-To: <CANKRQnhEFvubv0b63z34=_xn4x4q=20enofqPrMsFetj1x7-NQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cirrus.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Dec 5, 2011, at 8:01 PM, "Tomoya MORINAGA" <tomoya.rohm@gmail.com> wrote:

> 2011/12/6 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>>> According to "machine.txt", I created this machine driver referring
>>> corgi.c/spitz.c.
>>> However, corgi.c/spitz.c. don't look obeying your saying.
>> 
>> You really need to look at current drivers to make sure you're following
>> current best practice - older drivers, particularly for obsolte hardware
>> like the Zaurus machines, may well not reflect the current best practices.
> 
> I see.
> I won't read this docs.
> 
> BTW, Let me know the best practice of machine driver?
> I can't identify which driver is modern or not.
> 
> 
Check the OMAP and Samsung directories. Those are pretty current


