Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab1IIAmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:42:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36533 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab1IIAmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110908163742.GD3098@opensource.wolfsonmicro.com>
References: <1315494354-17597-1-git-send-email-mans.rullgard@linaro.org>
	<4E68DBF7.1030009@metafoo.de>
	<CAG5Tg6XxGP1YhQ0zW3f=1EkZfAmb9vj3pBemeSazpH1_CZ3OzQ@mail.gmail.com>
	<20110908163742.GD3098@opensource.wolfsonmicro.com>
Date: Thu, 8 Sep 2011 18:36:43 +0100
Message-ID: <CAG5Tg6XC8Kaw3iOH9GpTOpLH4qHWihC86gj2_f-W_+LgkeweBg@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: omap: convert per-board modules to
 platform drivers
From: Mans Rullgard <mans.rullgard@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, linaro-dev@lists.linaro.org,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 September 2011 17:37, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Sep 08, 2011 at 04:41:30PM +0100, Mans Rullgard wrote:
>> On 8 September 2011 16:15, Lars-Peter Clausen <lars@metafoo.de> wrote:
>
>> > Use different device driver names for different drivers.
>
>> I guess this worked by accident on my system.
>
>> Are there any other changes needed?
>
> Check the N810 code - it looks like that driver should be taking
> platform data to distinguish between the two models.  Possibly also rx51
> though I only looked at the diff.  Also it should probably be grabbing
> the clocks before it registers the card.

I don't see any what would need to distinguish models.  The current code
is not doing anything like that.  If it should, that's a separate issue.
Agree on the clocks for N810.

-- 
Mans Rullgard
Multimedia
mans.rullgard@linaro.org
