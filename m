Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab1ERBom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:44:42 -0400
Received: from antispam02.maxim-ic.com ([205.153.101.183]:42177 "EHLO
	antispam02.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734Ab1ERBol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:44:41 -0400
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 May 2011 21:44:41 EDT
X-ASG-Debug-ID: 1305682108-02256b0a51194a00004-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Taylor Hutt <thutt@chromium.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 17 May 2011 18:28:04 -0700
Subject: RE: [PATCH] Max98095: Move existing NULL check before pointer
 dereference.
Thread-Topic: [PATCH] Max98095: Move existing NULL check before pointer
 dereference.
X-ASG-Orig-Subj: RE: [PATCH] Max98095: Move existing NULL check before pointer
 dereference.
Thread-Index: AcwU951pfC2DEK7dSVml4HTWttgkUwAAQAIQ
Message-ID: <B2150E1E4418E1438554A300EA5040E40DDDA179DA@ITSVLEX06.it.maxim-ic.internal>
References: <1305680634-10484-1-git-send-email-thutt@chromium.org>
In-Reply-To: <1305680634-10484-1-git-send-email-thutt@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: maxdalex01.maxim-ic.internal[10.16.15.101]
X-Barracuda-Start-Time: 1305682110
X-Barracuda-URL: http://192.168.10.183:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.02
X-Barracuda-Spam-Status: No, SCORE=0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=THREAD_INDEX, THREAD_TOPIC
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64048
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 THREAD_INDEX           thread-index: AcO7Y8iR61tzADqsRmmc5wNiFHEOig==
	0.01 THREAD_TOPIC           Thread-Topic: ...(Japanese Subject)...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011, Taylor Hutt wrote:

> Visual inspection shows that max98095_put_eq_enum() and
> max98095_put_bq_enum() each have a possible NULL deref of 'pdata'.
> 
> This change moves the NULL check above the use.
> 
> BUG=none
> TEST=Visual inspection

Mark, this patch looks good.
Thank you Taylor.

