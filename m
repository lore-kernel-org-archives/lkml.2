Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912Ab0GPJya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:54:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51935 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964893Ab0GPJy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=wdJHMwOpVcozrCM1lPCWNPGj6BtI52eL8ulCoQt6G310csMvPvNJhuYL7wZ11tYVlk
         RsiS3dXOOwa6NXtdbAJpmEKKKainiJcot5ncnjG19ViI/THrzaB2QIsRLaUm6sU9pWSz
         IY0JHMrBHXAtgwi8HCLlNGjVjogXt9nwGLKTg=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100716093625.GD18376@sirena.org.uk>
References: <1279272408.2594.1.camel@mola> <20100716093625.GD18376@sirena.org.uk>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 16 Jul 2010 17:54:08 +0800
Message-ID: <AANLkTikMGIj-0WKXFT1Y6c7l1ObtVDx_j5pYOA_esvwG@mail.gmail.com>
Subject: Re: [PATCH] twl6040: fix wrong kfree in twl6040_remove and 
	twl6040_codec_remove
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Margarita Olaya Cabrera <magi.olaya@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mark,

2010/7/16 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Jul 16, 2010 at 05:26:48PM +0800, Axel Lin wrote:
>> Memory allocation part:
>> We allocate a memory in twl6040_codec_probe():
>>         priv = kzalloc(sizeof(struct twl6040_data), GFP_KERNEL);
>>         twl6040_codec = codec = &priv->codec;
>
> Could you please try to take on board the feedback you were given
> yesterday about this sort of stuff?  Both the feedback about formatting
> your patch so it's easy to apply and the collisions with other, more
> substantial, work that's going on?
>
Ok. I will resend the patch.
( I just thought it may takes some time for review )
( Due a vacation this weekend, I'll do it next Monday )

Regards,
Axel
