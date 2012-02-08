Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2BHKSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:18:06 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50090 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2BHKSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:18:04 -0500
MIME-Version: 1.0
In-Reply-To: <20120206162017.GM3070@opensource.wolfsonmicro.com>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
	<7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
	<alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6>
	<20120124202203.GD1135@opensource.wolfsonmicro.com>
	<alpine.DEB.2.02.1201242144580.1998@hadrien>
	<20120126110506.GB2611@pengutronix.de>
	<alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6>
	<20120126112242.GA9401@opensource.wolfsonmicro.com>
	<alpine.DEB.2.02.1201280801230.2045@hadrien>
	<20120206162017.GM3070@opensource.wolfsonmicro.com>
Date: Wed, 8 Feb 2012 18:18:03 +0800
Message-ID: <CAA+hA=Qu0z15vkskBOZdnEMqxmOV5Dk-gmA1ZJtJtuY0e=MRFA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
From: Dong Aisheng <dongas86@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 12:20 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sat, Jan 28, 2012 at 08:03:34AM +0100, Julia Lawall wrote:
>
>> patch against
>> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
>
> Hrm, I know there had been some debate about what to generate against
> but this now once again fails to apply against for-3.4...  No idea
> what's going on there and I didn't investigate the conflicts, sorry.
>
> I had been waiting in the vauge hope that some of the mxs maintainers
> would review.
>
I also failed to apply it against for-3.4.
It seemed the conflicts are a lot.

Hi Julia,

Can you regenerate the patch based on Mark's for-3.4 branch?

BTW, i wonder if this patch's title should be changed a bit
since what this patch does is not adding missing iounmap anymore.
Maybe like: ASoC: mxs-saif: convert to use devm_kmalloc and its friends.

Regards
Dong Aisheng
