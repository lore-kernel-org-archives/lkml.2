Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2BHMli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:41:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48990 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab2BHMlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:41:37 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Girdwood, Liam" <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH] davinci: CQ93VC: remove machine specific header
	file inclusion from codec driver
Thread-Topic: [RESEND PATCH] davinci: CQ93VC: remove machine specific header
	file inclusion from codec driver
Thread-Index: AQHMz8hZtO8ihD6Xyky64ge+IUf4m5YzHRPQ
Date: Wed, 8 Feb 2012 12:41:14 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753174E3EC@DBDE01.ent.ti.com>
References: <1326194863-31194-1-git-send-email-manjunath.hadli@ti.com>
 <20120110184741.GG7164@opensource.wolfsonmicro.com>
In-Reply-To: <20120110184741.GG7164@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.181.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, Jan 11, 2012 at 00:17:41, Mark Brown wrote:
> On Tue, Jan 10, 2012 at 04:57:43PM +0530, Manjunath Hadli wrote:
> > remove unnecessary inclusion of machine specific header file 
> > mach/dm365.h from cq93vc.c voice codec driver which comes in the way 
> > of platform code consolidation.
> 
> Applied but please do try to use a subject line appropriate for the subsystem you're contributing to.
I still can't find this patch in the mainline, any issues?

Regards,
--Manju
> 

