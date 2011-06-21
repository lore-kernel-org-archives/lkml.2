Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1FUApW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:45:22 -0400
Received: from antispam01.maxim-ic.com ([205.153.101.182]:34921 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab1FUApT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:45:19 -0400
X-ASG-Debug-ID: 1308617117-02ae980a393843c0003-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Taylor Hutt <thutt@chromium.org>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Olof Johansson <olofj@chromium.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 Jun 2011 17:43:58 -0700
Subject: RE: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware
 revision.
Thread-Topic: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware
 revision.
X-ASG-Orig-Subj: RE: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware
 revision.
Thread-Index: AcwvqXuuZqLUunoKTr6UyAlqcV8IYwAAMi1A
Message-ID: <B2150E1E4418E1438554A300EA5040E40DDEC16D42@ITSVLEX06.it.maxim-ic.internal>
References: <1308596072-17158-1-git-send-email-thutt@chromium.org>
 <20110621002322.GE1905@opensource.wolfsonmicro.com>
In-Reply-To: <20110621002322.GE1905@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: maxdalex02.maxim-ic.internal[10.16.15.104]
X-Barracuda-Start-Time: 1308617117
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.02
X-Barracuda-Spam-Status: No, SCORE=0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=THREAD_INDEX, THREAD_TOPIC
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66649
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 THREAD_INDEX           thread-index: AcO7Y8iR61tzADqsRmmc5wNiFHEOig==
	0.01 THREAD_TOPIC           Thread-Topic: ...(Japanese Subject)...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011, Mark Brown wrote:
> On Mon, Jun 20, 2011 at 11:54:32AM -0700, Taylor Hutt wrote:
> > The base hardware revision of the Maxim 98095 part is 0x40; the code
> > which outputs the revision of the hardware has been updated to
> > properly use uppercase alphabetic values for the revision numbers.
> 
> Are you sure that this is true for all devices that might be supported
> by the driver (I'm guessing there may be other variants)?  There's
> often a drift between silicon and package revisions which gets papered 
> over by datasheets and ignored by drivers.

I checked with hardware engineering and was told 0x40=RevA, 0x41=RevB..

Would a raw value or the use of a 0x3F bit mask be more acceptable?

Peter
