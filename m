Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1K1Rxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:53:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59741 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1K1Rxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:53:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Date: Mon, 28 Nov 2011 17:53:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: myungjoo.ham@gmail.com, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com> <201111251402.28016.arnd@arndb.de> <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
In-Reply-To: <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111281753.45287.arnd@arndb.de>
X-Provags-ID: V02:K0:Mfar0PEiUo61qVO6VEHt3HFmICF1FO0IuJmygyERwAv
 1iwAFMx+BR3UqJ/278qApMwcPSmVtGua1kNCRpIv9NbtV7PfS7
 LzveVzBC+/jdyRN7ZfzRe7+SwPBvBW8uZ+y3RMovLkCoNYeydr
 KRb3LHZAFWojhsNLnTRFsF0ZIwLOTV+tEmCj+doVWATphgo0ib
 f2d8C5kbPvZhODeLUoLohEMDiCxkBeVIgRhMKHChJnt2t7rqcG
 XkyywYJZMxA+D7tRl8SX+ZyHrDLDVUxtmekYpovugcJvCoStIy
 3AV4GMRc3ysjHG7ZePmoQN6uEMmLfbWGpACSKVHfyYjxWUDNXE
 MbIhANRO3IJidytb0NY4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 November 2011, Linus Walleij wrote:
> > How does this relate to the new "pinmux" subsystem that Linus Walleij
> > maintains? Would it be useful to integrate your driver into pinmux
> > instead of starting a new subsystem?
> 
> Looks unrelated to pinmux but very useful.

Ok, got it. So while pinmux controls the setting of some pins, this one
generates software events when the state is changed from the outside.

	Arnd
