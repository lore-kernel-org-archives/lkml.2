Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab2BIShp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:37:45 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:17362
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754136Ab2BIShl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:37:41 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz9371I542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Liam Girdwood <lrg@ti.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] sound/soc/mxs/mxs-saif.c: use devm_ functions
Thread-Topic: [PATCH] sound/soc/mxs/mxs-saif.c: use devm_ functions
Thread-Index: AQHM5oUgmXaGhY0fWUK7l1I9qEJRH5Y05LBQgAABqiA=
Date: Thu, 9 Feb 2012 18:37:35 +0000
Message-ID: <7FE21149F4667147B645348EC60578850C187F@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1328721262-20993-1-git-send-email-Julia.Lawall@lip6.fr>
 <7FE21149F4667147B645348EC60578850C1864@039-SN2MPN1-012.039d.mgd.msft.net>
In-Reply-To: <7FE21149F4667147B645348EC60578850C1864@039-SN2MPN1-012.039d.mgd.msft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.60.121.130]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Dong Aisheng-B29396
> Sent: Thursday, February 09, 2012 10:35 AM
> To: Julia Lawall; Liam Girdwood
> Cc: kernel-janitors@vger.kernel.org; Mark Brown; Jaroslav Kysela; Takashi Iwai;
> alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] sound/soc/mxs/mxs-saif.c: use devm_ functions
> 
> > -----Original Message-----
> > From: Julia Lawall [mailto:Julia.Lawall@lip6.fr]
> > Sent: Wednesday, February 08, 2012 9:14 AM
> > To: Liam Girdwood
> > Cc: kernel-janitors@vger.kernel.org; Mark Brown; Jaroslav Kysela;
> > Takashi Iwai; alsa-devel@alsa-project.org;
> > linux-kernel@vger.kernel.org; Dong Aisheng-B29396
> > Subject: [PATCH] sound/soc/mxs/mxs-saif.c: use devm_ functions
> > Importance: High
> >
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > The various devm_ functions allocate memory that is released when a
> > driver detaches.  This patch uses these functions for data that is
> > allocated in the probe function of a platform device and is only freed in the
> remove function.
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> > patch against
> > git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
> >
> I still failed to apply against for-3.4 branch.
> Can you switch to for-3.4 branch and then re-generate the patch based on it?
> 
Make sure update to the latest on for-3.4 branch for making the patch.

Regards
Dong Aisheng


