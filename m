Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1ALBnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 20:43:16 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35153 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab1ALBnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 20:43:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=uuMu8VSu/chsaUX+nKCJ0uWvxcM/gotQ1byCEkBC1f+4qSC6UkBsiUdirrSf/dB1x8
         3mRrqGBEdtDnAsgnT+v5aEkROl/x1ThNiifw/1tuLAtolyjHrR35kJ2ZNqUhlNlAGZ6K
         tupqPfCjTLHN5mP6CeXSrsKUWQqsY8PNu465k=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <AANLkTimkb4ic3G7rT-WiFtFdC+Sy5gVAikoQVXguVH4J@mail.gmail.com>
References: <1291726590.2760.3.camel@phoenix> <AANLkTimkb4ic3G7rT-WiFtFdC+Sy5gVAikoQVXguVH4J@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 12 Jan 2011 09:42:52 +0800
Message-ID: <AANLkTinxs8k2-gc03i6H_r0iONh1XtjrH-60dZ-0j+9g@mail.gmail.com>
Subject: Re: [PATCH] ASoC: Fix resource leak if soc_register_ac97_dai_link failed
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this isnt entirely correct.  soc_unregister_ac97_dai_link takes a
> pointer to a codec which card->rtd[i] is not.
> sound/soc/soc-core.c: In function ‘snd_soc_instantiate_card’:
> sound/soc/soc-core.c:1626: warning: passing argument 1 of
> ‘soc_unregister_ac97_dai_link’ from incompatible pointer type
> -mike
>

Ooops. my bad.
I will send a patch for 2.6.37 to fix it.
Thanks for report this bug.

Regards,
Axel
