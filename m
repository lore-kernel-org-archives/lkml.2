Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab1FUUth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:49:37 -0400
Received: from antispam01.maxim-ic.com ([205.153.101.182]:53792 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab1FUUtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:49:35 -0400
X-ASG-Debug-ID: 1308689372-02ae9816fa104ba0001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Taylor Hutt <thutt@chromium.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Olof Johansson <olofj@chromium.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jun 2011 13:48:02 -0700
Subject: RE: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware
	revision.
Thread-Topic: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware
	revision.
X-ASG-Orig-Subj: RE: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware
	revision.
Thread-Index: AcwwCiv9OUNv8scKToef3k4Vl7TfqwASd41g
Message-ID: <B2150E1E4418E1438554A300EA5040E40DDEC8CAD9@ITSVLEX06.it.maxim-ic.internal>
References: <1308596072-17158-1-git-send-email-thutt@chromium.org>
 <20110621002322.GE1905@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40DDEC16D42@ITSVLEX06.it.maxim-ic.internal>
 <20110621011038.GA4322@opensource.wolfsonmicro.com>
 <20110621115547.GD25032@sirena.org.uk>
In-Reply-To: <20110621115547.GD25032@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: maxdalex02.maxim-ic.internal[10.16.15.104]
X-Barracuda-Start-Time: 1308689372
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.02
X-Barracuda-Spam-Status: No, SCORE=0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=THREAD_INDEX, THREAD_TOPIC
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66729
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 THREAD_INDEX           thread-index: AcO7Y8iR61tzADqsRmmc5wNiFHEOig==
	0.01 THREAD_TOPIC           Thread-Topic: ...(Japanese Subject)...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011, Mark Brown wrote:
> On Tue, Jun 21, 2011 at 02:10:39AM +0100, Mark Brown wrote:
> > On Mon, Jun 20, 2011 at 05:43:58PM -0700, Peter Hsiang wrote:
> 
> > > I checked with hardware engineering and was told 0x40=RevA,
> 0x41=RevB..
> 
> This means if you're OK with it I can apply the patch as-is, BTW.

Acked-by: Peter Hsiang <peter.hsiang@maxim-ic.com>

