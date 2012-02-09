Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab2BISpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:45:44 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:42973
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239Ab2BISpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:45:42 -0500
X-IronPort-AV: E=Sophos;i="4.73,391,1325458800"; 
   d="scan'208";a="130779679"
Date: Thu, 9 Feb 2012 19:45:41 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Dong Aisheng-B29396 <B29396@freescale.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] sound/soc/mxs/mxs-saif.c: use devm_ functions
In-Reply-To: <7FE21149F4667147B645348EC60578850C1864@039-SN2MPN1-012.039d.mgd.msft.net>
Message-ID: <alpine.DEB.2.02.1202091945150.1845@localhost6.localdomain6>
References: <1328721262-20993-1-git-send-email-Julia.Lawall@lip6.fr> <7FE21149F4667147B645348EC60578850C1864@039-SN2MPN1-012.039d.mgd.msft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012, Dong Aisheng-B29396 wrote:

>> -----Original Message-----
>> From: Julia Lawall [mailto:Julia.Lawall@lip6.fr]
>> Sent: Wednesday, February 08, 2012 9:14 AM
>> To: Liam Girdwood
>> Cc: kernel-janitors@vger.kernel.org; Mark Brown; Jaroslav Kysela; Takashi Iwai;
>> alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org; Dong Aisheng-B29396
>> Subject: [PATCH] sound/soc/mxs/mxs-saif.c: use devm_ functions
>> Importance: High
>>
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> The various devm_ functions allocate memory that is released when a driver
>> detaches.  This patch uses these functions for data that is allocated in the
>> probe function of a platform device and is only freed in the remove function.
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>> patch against git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
>>
> I still failed to apply against for-3.4 branch.
> Can you switch to for-3.4 branch and then re-generate the patch based on it?

OK.

julia
