Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0JNDSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 23:18:33 -0400
Received: from antispam01.maxim-ic.com ([205.153.101.182]:34342 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab0JNDSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 23:18:32 -0400
X-ASG-Debug-ID: 1287026311-3479865e0001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Date: Wed, 13 Oct 2010 20:18:44 -0700
X-ASG-Orig-Subj: RE: [PATCH] ASoC: Add max98088 CODEC driver
Subject: RE: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Topic: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Index: Actqwf9O6M34376xSJ65EFlETbwRxwAi/KMg
Message-ID: <B2150E1E4418E1438554A300EA5040E40D470D7DEA@ITSVLEX06.it.maxim-ic.internal>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
 <20101013103224.GK6424@rakim.wolfsonmicro.main>
In-Reply-To: <20101013103224.GK6424@rakim.wolfsonmicro.main>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 14 Oct 2010 03:18:53.0891 (UTC) FILETIME=[87B9C130:01CB6B4E]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1287026311
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010, Mark Brown wrote:
> On Tue, Oct 12, 2010 at 06:20:10PM -0700, Peter Hsiang wrote:
> 
> This looks pretty good, waiting for Liam's review but I think we can do
> further stuff incrementally.  Minor comments:
> 
> > +
> > +       /* Setup an array of texts for the equalizer enum.
> > +        * This is based on Mark Brown's equalizer driver code.
> > +        * It has been extended to support multiple equalizers.
> > +        */
> 
> The code that you're basing this on supports multiple equalizers too -
> things like the WM8994 have several.  Given that all those supported by
> the original code are identical there didn't seem to be any point in
> restricting which EQ a given setup can be deployed on - it's just one
> more thing that can go wrong.

Thanks - that is a very good idea.  I have implemented it and will
submit it shortly.

