Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0IWR4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:56:20 -0400
Received: from antispam02.maxim-ic.com ([205.153.101.183]:57909 "EHLO
	antispam02.maxim-ic.com.maxim-ic.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753841Ab0IWR4T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:56:19 -0400
X-ASG-Debug-ID: 1285264578-733938260001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Date: Thu, 23 Sep 2010 10:56:38 -0700
X-ASG-Orig-Subj: RE: [PATCH] ASoC: Add max98088 CODEC driver
Subject: RE: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Topic: [PATCH] ASoC: Add max98088 CODEC driver
Thread-Index: ActbF5KVu2HNVwMyRkGkQRt/0GqgAgALwxKw
Message-ID: <B2150E1E4418E1438554A300EA5040E40D46E1BE7C@ITSVLEX06.it.maxim-ic.internal>
References: <B2150E1E4418E1438554A300EA5040E40D469C1248@ITSVLEX06.it.maxim-ic.internal>
 <20100923120443.GF25663@rakim.wolfsonmicro.main>
In-Reply-To: <20100923120443.GF25663@rakim.wolfsonmicro.main>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Sep 2010 17:56:40.0838 (UTC) FILETIME=[ACFF5A60:01CB5B48]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1285264578
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010, Mark Brown wrote:
> On Wed, Sep 22, 2010 at 07:58:48PM -0700, Peter Hsiang wrote:
> 
> > This patch adds the MAX98088 CODEC driver.
> 
> > Signed-off-by: Peter Hsiang <peter.hsiang@maxim-ic.com>
> 
> When you submitted the driver on the 31st of August my first comment in
> the review was:
> 
> | The major issue with this is that the driver needs to be updated to
> | current ASoC versions - you should always be working against the trees
> | that are in linux-next for new drivers.  For ASoC you should be looking
> | at:
> 
> |   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git
> 
> Currently you should be looking at for-next or for-2.6.37, though the
> branch names will change as kernel development moves forward.

What is the git command line path/parameter for for-next or for-2.6.37?
Something equivalent to...
....pub/scm/linux/kernel/git/next/linux-next.git 

Why do the files in git/broonie/sound-2.6.git look older than -next?
For example, it's missing soc-cache.c, and the codec drivers there
use the old I/O method.  Same drivers in -next are newer and use the soc-cache.
 
> 
> This must be rectified before the driver can be considered for inclusion
> in the kernel.  As things stand the code will not compile.
