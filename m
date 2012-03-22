Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2CVAMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:12:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52101 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2CVAMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:12:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120321160913.GF3226@opensource.wolfsonmicro.com>
References: <1331275160-31757-1-git-send-email-tomoya.rohm@gmail.com>
	<1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
	<20120321160913.GF3226@opensource.wolfsonmicro.com>
Date: Thu, 22 Mar 2012 09:12:39 +0900
Message-ID: <CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
Subject: Re: [PATCH v5] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 1:09 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> So, I just said to the SPEAr guys that I really want to see support for
> non-cyclic dmaengine added to the helper library rather than open
> coding.  We're seeing lots of platforms moving to dmaengine (as well as
> those that are in already yours is one of three out of tree platforms
> I'm aware of that have actively submitted stuff) and with this number of
> platforms we really need to get stuff factored out - there's enough
> people working on these platforms that it should be possible to add the
> support to the dmaengine library code.

Do you mean you don't accept our platform/machine driver's patches
unless your DMA library will have supported non-cyclic dmaengine ?
Or if I'll modify your minor comments, can you accept our patches ?

thanks.

-- 
ROHM Co., Ltd.
tomoya
