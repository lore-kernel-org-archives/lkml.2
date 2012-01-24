Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2AXKze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 05:55:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59803 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912Ab2AXKzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 05:55:33 -0500
Date: Tue, 24 Jan 2012 10:55:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: Hang up at .prepare( )
Message-ID: <20120124105528.GA20519@opensource.wolfsonmicro.com>
References: <CANKRQngqJaAq7ucg3VzCMs+-KFXTSuJG=uq4d0kQ95gEMFfB4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQngqJaAq7ucg3VzCMs+-KFXTSuJG=uq4d0kQ95gEMFfB4w@mail.gmail.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 06:38:45PM +0900, Tomoya MORINAGA wrote:

> I've faced issue when installing these drivers,
> system becomes hang up at async_synchronize_full_domain() of
> dapm_power_widgets()
> in .prepare().

> Do you have any information about this hang up ?

> I show details below.

What efforts have you made to debug this yourself?  Clearly this is not
happening for other people, perhaps it is related to something you have
in your drivers - have you addressed the issues raised with them?
