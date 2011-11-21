Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab1KUTpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:45:46 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:56271
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614Ab1KUTpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:45:45 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zz9371Kc89bh542M1432Nzz1202hzz8275bh8275dhz2dh668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LV107Z-02-3BD-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Artur Flinta <aflinta@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "airlied@redhat.com" <airlied@redhat.com>
Subject: RE: [Bugreport] Screen backllight issues on FirePro M5950 (HP
 EliteBook 8560w)
Thread-Topic: [Bugreport] Screen backllight issues on FirePro M5950 (HP
 EliteBook 8560w)
Thread-Index: AQHMqIBa5kcb6PI4Bk2VoEj3ifwcJpW3uwzw
Date: Mon, 21 Nov 2011 19:45:35 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D00AFE6A5C@sausexdag02.amd.com>
References: <CAEPe-G+MrLWHgugZhvDXrPL8DW+BSsDJ8SrPaT=tbeopUBn6DA@mail.gmail.com>
In-Reply-To: <CAEPe-G+MrLWHgugZhvDXrPL8DW+BSsDJ8SrPaT=tbeopUBn6DA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.53.84]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pALJk0Nj026918

> -----Original Message-----
> From: Artur Flinta [mailto:aflinta@gmail.com]
> Sent: Monday, November 21, 2011 2:04 PM
> To: linux-kernel@vger.kernel.org
> Cc: Deucher, Alexander; airlied@redhat.com
> Subject: [Bugreport] Screen backllight issues on FirePro M5950 (HP EliteBook
> 8560w)
> 
> Hi!
> 
> I have HP Elitebook 8560w with FirePro M5950, Fedora 16, kernel 3.1.1, xorg
> ati driver 6.14.3 and issues with screen backlight - can't dim it.I can write to
> /sys/class/backlight/acpi_video0/brightness values from 0 to 20 (as stated in
> max_brightness), but it have no effect on the screen, values in brightness as
> well as in actual_brightness reflects written number.
> Before system boot, I can change brightness of the screen, and it persist in
> operating system. Value of the /sys/class/backlight/acpi_video0/brightness
> indicates maximum brightness (20) even if minimal was set before boot. It
> seems that built in kernel radeon driver does not correctly handle backlight
> on this hardware.

The driver doesn't handle the backlight at all.  We leave it up to ACPI.

Alex

> 
> Regards
> Artur
> --
> KaÅ¼dy problem ma swoje rozwiÄ…zanie, zatem jeÅ¼eli nie ma rozwiÄ…zania to nie
> ma problemu.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
