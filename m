Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab0GSBlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 21:41:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35572 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab0GSBll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 21:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=RuX3wXUwqZ2C3XroaTMyipqjhSalfXJbP1n+suXvRmsPt5qkDzAMeZ/lAmRIKzUvAz
         oEIlSHgRR5HLOZUUHFvUalwyl2+0Kx+zeqJ0btlu0sUGWOYhJ38yuWH6BtkoKFlxvZI2
         8wEftzQlxmBc3uyOtx39ft+Bty6hiIqYCRas4=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100715085932.GA23529@rakim.wolfsonmicro.main>
References: <1279162147.29294.2.camel@mola> <20100715085932.GA23529@rakim.wolfsonmicro.main>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 19 Jul 2010 09:41:20 +0800
Message-ID: <AANLkTikSPYLmrIVkyD_GOVZ76Bkha7DNxED33ZZgQNKJ@mail.gmail.com>
Subject: Re: [PATCH 0/12] sound/alsa/soc/codec: fix memory leak and resource 
	relaim in error path
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Tejun Heo <tj@kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mark,

2010/7/15 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Thu, Jul 15, 2010 at 10:49:07AM +0800, Axel Lin wrote:
>
>> [PATCH 1/12] ad1836: fix a memory leak if another ad1836 is registered
>> [PATCH 2/12] ak4642: fix a memory leak if failed to initialise AK4642
>> [PATCH 3/12] da7210: fix a memory leak if failed to initialise da7210 audio codec
>> [PATCH 4/12] wm8523: fix resource reclaim in wm8523_register error path
>> [PATCH 5/12] wm8711: fix a memory leak if another WM8711 is registered
>> [PATCH 6/12] wm8904: fix resource reclaim in wm8904_register error path
>> [PATCH 7/12] wm8940: fix resource reclaim in wm8940_register error path
>> [PATCH 8/12] wm8955: fix resource reclaim in wm8955_register error path
>> [PATCH 9/12] wm8961: fix resource reclaim in wm8961_register error path
>> [PATCH 10/12] wm8974: fix a memory leak if another WM8974 is registered
>> [PATCH 11/12] wm8978: fix a memory leak if another WM8978 is registered
>> [PATCH 12/12] wm9081: fix resource reclaim in wm9081_register error path
>
> If you're going to be submiting large batches of small patches like this
> it would be really helpful if you could make sure you format the subject
> lines for your patches so that they match the standards for the area of
> the kernel you're updating.  This makes them much easier to apply.
>

After checking Liam's multi-component branch, I think this serial of
fix is not necessary.
If you think it still has value to merge this serial of fix for
current implementation, just let me know.

Regards,
Axel
