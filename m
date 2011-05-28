Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab1E1BsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 21:48:11 -0400
Received: from antispam02.maxim-ic.com ([205.153.101.183]:40299 "EHLO
	antispam02.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab1E1BsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 21:48:07 -0400
X-ASG-Debug-ID: 1306547283-02256b0a50385d8000a-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter Hsiang <cdefgab1288@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Date: Fri, 27 May 2011 18:45:39 -0700
Subject: RE: [PATCH] ASoC: Remove redundant freq assignment for
 max98095->sysclk/max98088->sysclk
Thread-Topic: [PATCH] ASoC: Remove redundant freq assignment for
 max98095->sysclk/max98088->sysclk
X-ASG-Orig-Subj: RE: [PATCH] ASoC: Remove redundant freq assignment for
 max98095->sysclk/max98088->sysclk
Thread-Index: AcwcgxWYXh3i+Z+FR6iZSGb9tGJKoQAVRyQw
Message-ID: <B2150E1E4418E1438554A300EA5040E40DDE76600D@ITSVLEX06.it.maxim-ic.internal>
References: <1306510253.19556.36.camel@phoenix>
In-Reply-To: <1306510253.19556.36.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Barracuda-Connect: maxdalex01.maxim-ic.internal[10.16.15.101]
X-Barracuda-Start-Time: 1306547286
X-Barracuda-URL: http://192.168.10.183:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.02
X-Barracuda-Spam-Status: No, SCORE=0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=THREAD_INDEX, THREAD_TOPIC
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64867
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 THREAD_INDEX           thread-index: AcO7Y8iR61tzADqsRmmc5wNiFHEOig==
	0.01 THREAD_TOPIC           Thread-Topic: ...(Japanese Subject)...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4S1mJ0q023564

On Fri, May 27, 2011, Alex Lin wrote:
> Current implementation set max98095->sysclk/max98088->sysclk to freq twice.
> Set it once is enough, this patch removes the first assignment in case
> we may set invalid clock frequency to max98095->sysclk/max98088->sysclk.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> hi Peter,
> I don't have this hardware handy. Can you help to test it?
> Thanks,
> Axel
> 

Acked-by: Peter Hsiang <peter.hsiang@maxim-ic.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
