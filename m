Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab1LBCUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:20:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45133 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab1LBCUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:20:23 -0500
MIME-Version: 1.0
In-Reply-To: <20111202010644.GC31948@opensource.wolfsonmicro.com>
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
	<20111128132317.GD8275@opensource.wolfsonmicro.com>
	<CANKRQng3YtYZggVWp3BWyaWyaHAbN1hccJksWELnv2co37rEcQ@mail.gmail.com>
	<20111129122916.GM2851@opensource.wolfsonmicro.com>
	<CANKRQnjpYDJWfJO-G5HsE6es7metHeqgP32R3eo99MaE2zdNpQ@mail.gmail.com>
	<s5hhb1kvix5.wl%tiwai@suse.de>
	<CANKRQniRonz5UcQ-KgnFJptPkqgWWrJsFuW31f8bWCf_xx-tTA@mail.gmail.com>
	<20111201111137.GC2915@opensource.wolfsonmicro.com>
	<CANKRQng4+fKY-3FLMKB_Z-JLB-Xhqpvx90uecFNQCS=NDG55pw@mail.gmail.com>
	<20111202010644.GC31948@opensource.wolfsonmicro.com>
Date: Fri, 2 Dec 2011 11:20:22 +0900
Message-ID: <CANKRQnjrpBvWRWssazs_bpQcidbRfSivdrYp10pxtX5kMTPfWg@mail.gmail.com>
Subject: Re: [PATCH v3] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/2 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Dec 02, 2011 at 09:33:23AM +0900, Tomoya MORINAGA wrote:
>
>> Which description do you want ?
>
>> EQ Band1 Volume
>> EQ Band1 Switch
>
>> or
>
>> EQ Band1 Input Volume
>> EQ Band1 Input Switch
>
> Either is fine, if I had to pick one I'd go with the first one.  The
> important thing is that Switch and Volume use the same string.
>

OK, I would use the first one.

Thanks,

tomoya
