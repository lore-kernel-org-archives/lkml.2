Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab0GTPDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:03:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62589 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194Ab0GTPC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=GsZJP7vbqDVoeAsqOQ1xKF1tKF7rQhAEObwVAo5EywXFeo5sBS1dqwG5BayPLZO6ob
         CUtsPFh7QQF3G6boKHmspMzgrNpBlzZHVRGwBasOa+LjqxFi02qcaDF6VR/t/xnEI2mZ
         gmIjxm/AM20Bp2bi6CUH6wEyK/DUlR0mTbSIU=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100720110722.GN10222@rakim.wolfsonmicro.main>
References: <1279619362.11179.2.camel@mola> <20100720110722.GN10222@rakim.wolfsonmicro.main>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 20 Jul 2010 23:02:37 +0800
Message-ID: <AANLkTinTT3_yy02wGJfKwannKT2rrZN899JKrdlvtLz7@mail.gmail.com>
Subject: Re: [PATCH] wm8960: fix compile error
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

2010/7/20 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Jul 20, 2010 at 05:49:22PM +0800, Axel Lin wrote:
>
>> This patch is against Liam's multi-component branch.
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> but please do try to bear in mind the feedback you've previously been
> given about formatting your patches so they can be easily applied.  You
I'm a little bit confused about the meaning of "formatting your patches"?
Do you mean my patches cannot be applied by git am command? or?
( I tried the git am command with the mail I sent and it looks ok )

> probably also want to look at the CC list for your patches, I'm not sure
> why you're CCing Tejun here.

I get the CC list by get_maintainer.pl. Looks like the script gives me wrong
CC list.

Regards,
Axel
