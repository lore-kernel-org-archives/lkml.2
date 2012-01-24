Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab2AXLaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:30:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63324 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2AXLaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:30:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120124105528.GA20519@opensource.wolfsonmicro.com>
References: <CANKRQngqJaAq7ucg3VzCMs+-KFXTSuJG=uq4d0kQ95gEMFfB4w@mail.gmail.com>
	<20120124105528.GA20519@opensource.wolfsonmicro.com>
Date: Tue, 24 Jan 2012 20:30:17 +0900
Message-ID: <CANKRQnibHChSVEOvsDuKTXcnDkx5KQAMOxfheocTJt+ar0CgPw@mail.gmail.com>
Subject: Re: Hang up at .prepare( )
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/24 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> What efforts have you made to debug this yourself?  Clearly this is not
> happening for other people, perhaps it is related to something you have
> in your drivers - have you addressed the issues raised with them?

I said previously, "our ASoC drivers" not others.
Of course, I understand current upstreamed drivers don't have this issue.
I just asked "If someone faced the same issue when debugging, let me
know about it."

thanks,
