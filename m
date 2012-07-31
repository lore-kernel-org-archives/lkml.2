Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab2GaPQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:16:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754967Ab2GaPQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:16:01 -0400
Date: Tue, 31 Jul 2012 16:15:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/5] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
Message-ID: <20120731151559.GB4468@opensource.wolfsonmicro.com>
References: <1343745944-18418-1-git-send-email-lee.jones@linaro.org>
 <1343745944-18418-2-git-send-email-lee.jones@linaro.org>
 <20120731145614.GZ4468@opensource.wolfsonmicro.com>
 <5017F514.4030106@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5017F514.4030106@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 04:09:08PM +0100, Lee Jones wrote:
> On 31/07/12 15:56, Mark Brown wrote:

> >To reiterate, this is in *no* way urgent or even a bug fix.

> It fixes sound in our driver.

> Without this the card failes to instantiate.

You're kidding, right?  Fix the actual error.

> Isn't the return code incorrect? There are a multitude of reasons
> why snd_soc_dapm_new_control() would fail. No-memory is just one of
> them, so why do we force this probable lie?

I don't think anyone actually cares what the error code is, feel free to
pick another random number.
