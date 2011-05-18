Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab1ERNzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:55:24 -0400
Received: from antispam01.maxim-ic.com ([205.153.101.182]:54173 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab1ERNzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:55:23 -0400
X-ASG-Debug-ID: 1305726921-02ae981bb94acdc0001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Taylor Hutt <thutt@chromium.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 May 2011 06:53:37 -0700
Subject: RE: [PATCH] Max98095: Move existing NULL check before pointer
 dereference.
Thread-Topic: [PATCH] Max98095: Move existing NULL check before pointer
 dereference.
X-ASG-Orig-Subj: RE: [PATCH] Max98095: Move existing NULL check before pointer
 dereference.
Thread-Index: AcwVKiT4UaRoBSybQWCEfphMdF/I6gAONdof
Message-ID: <B2150E1E4418E1438554A300EA5040E40DDD8525E2@ITSVLEX06.it.maxim-ic.internal>
References: <1305680634-10484-1-git-send-email-thutt@chromium.org>
 <B2150E1E4418E1438554A300EA5040E40DDDA179DA@ITSVLEX06.it.maxim-ic.internal>,<20110518070619.GA3065@opensource.wolfsonmicro.com>
In-Reply-To: <20110518070619.GA3065@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: maxdalex02.maxim-ic.internal[10.16.15.104]
X-Barracuda-Start-Time: 1305726921
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.02
X-Barracuda-Spam-Status: No, SCORE=0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=THREAD_INDEX, THREAD_TOPIC
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64099
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 THREAD_INDEX           thread-index: AcO7Y8iR61tzADqsRmmc5wNiFHEOig==
	0.01 THREAD_TOPIC           Thread-Topic: ...(Japanese Subject)...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011, Mark Brown wrote:

> On Tue, May 17, 2011 at 06:28:04PM -0700, Peter Hsiang wrote:
> 
> > Mark, this patch looks good.
> 
> I can add your Acked-by?

Ok thanks.
