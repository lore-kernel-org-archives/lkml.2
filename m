Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0FOOrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:47:53 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49534 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab0FOOrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i90KSOn238f1fcIJ/JyAMzwiwdOzGuM9CcJp2DWhEOEJ88P1Rf+xAszsUupzERbs/N
         m0L9sdsJqFgNPv9Gk9Pl/KdZZTI5XUVAnXRJasctxtZ4xnCRIR5zbxZ8YA6JHFYocLjp
         NFbWQzSNXKfzWSPwTXu4C/BD0we897nrV8mjk=
MIME-Version: 1.0
In-Reply-To: <201006150909.01958.fabio.giovagnini@aurion-tech.com>
References: <20100604050007.GD31868@linux-sh.org>
	<201006150909.01958.fabio.giovagnini@aurion-tech.com>
Date: Tue, 15 Jun 2010 16:21:39 +0200
X-Google-Sender-Auth: IxrZVeoSONVrR54xOe-U78OjdJw
Message-ID: <AANLkTil4oxgn5iDQPp0qClrtFJUtuWKA62m40_5Dp9BR@mail.gmail.com>
Subject: Re: [GIT PULL] sh updates for 2.6.35-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Fabio Giovagnini <fabio.giovagnini@aurion-tech.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 09:09, Fabio Giovagnini
<fabio.giovagnini@aurion-tech.com> wrote:
> I Paul,
> I just finished my last application ald linux 2.6 jernel based.
> I'd like to upgrade my structure to the latest kernel for giving my apport
> into the development of sh7203 target.
> Can I have an account at
>
> master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Just replace "master.kernel.org:" by "git://git.kernel.org", and it will work
without an account. There may be a small delay, due to git.kernel.org
being synced
from master.kernel.org.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
