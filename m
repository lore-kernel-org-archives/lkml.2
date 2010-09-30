Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab0I3BUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:20:25 -0400
Received: from antispam02.maxim-ic.com ([205.153.101.183]:36538 "EHLO
	antispam02.maxim-ic.com.maxim-ic.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751343Ab0I3BUY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:20:24 -0400
X-ASG-Debug-ID: 1285809624-4d1261740001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Date: Wed, 29 Sep 2010 18:20:34 -0700
X-ASG-Orig-Subj: RE: [PATCH] ASoC: Add max98088 CODEC driver
Subject: RE: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Topic: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Index: ActgOq0dKRk7wRHbT6mf4sAq6B+UbAAAqG6Q
Message-ID: <B2150E1E4418E1438554A300EA5040E40D46F2DA19@ITSVLEX06.it.maxim-ic.internal>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <20100929033757.GB29975@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40D46F2D8D8@ITSVLEX06.it.maxim-ic.internal>
 <20100929221826.GC31934@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40D46F2D9E9@ITSVLEX06.it.maxim-ic.internal>
 <20100930005850.GB4517@opensource.wolfsonmicro.com>
In-Reply-To: <20100930005850.GB4517@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 30 Sep 2010 01:20:47.0327 (UTC) FILETIME=[B60566F0:01CB603D]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1285809624
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010, Mark Brown wrote:
> On Wed, Sep 29, 2010 at 05:52:08PM -0700, Peter Hsiang wrote:
> > On Wed, Sep 29, 2010, Mark Brown wrote:
> 
> > > You're looking for the non-DAPM equivalent of SND_SOC_DAPM_VALUE_MUX().
> 
> > This is a simple table lookup of a register value from the index
> > number given by SOC_ENUM, the same way it's been done in other drivers.
> 
> Yes, exactly.
> 
> > I found a "case snd_soc_dapm_value_mux:" in dapm_set_path_status()
> > Is this what you are referring to?
> > How is the code there relevant to this?
> 
> No, I'm referring to the fact that it provides an enum that allows
> arbatrary values to be set for each enum value rather than just allowing
> indexes as the standard SOC_ENUM does.  This is essentially what you've
> implemented, it would factor out the code so that others can use it too
> (and IIRC save you some code since IIRC you had more than one of these
> in the driver).

Thank you!

