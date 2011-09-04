Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab1IDQg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 12:36:59 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41275 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1IDQgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 12:36:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110904155459.GC21528@opensource.wolfsonmicro.com>
References: <1314971261.3699.0.camel@phoenix>
	<20110904155459.GC21528@opensource.wolfsonmicro.com>
Date: Sun, 4 Sep 2011 18:36:51 +0200
Message-ID: <CACTFLANKizyLnK0JsOoSoySzKQ-cYOoYjHHfxjRVjbeqnec9xg@mail.gmail.com>
Subject: Re: [PATCH] ASoC: Add missing platform_device_put in
 raumfeld_audio_init error path
From: Daniel Mack <zonque@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 4, 2011 at 5:55 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Sep 02, 2011 at 09:47:41PM +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Applied, thanks.

Feel free to add my Acked-by as well, if it's not too late.


Thanks,
Daniel
