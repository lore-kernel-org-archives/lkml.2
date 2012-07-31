Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2GaNmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:42:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32980 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753750Ab2GaNmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:42:16 -0400
Date: Tue, 31 Jul 2012 14:42:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
Message-ID: <20120731134214.GK4468@opensource.wolfsonmicro.com>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
 <1343741493-17671-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343741493-17671-3-git-send-email-lee.jones@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 02:31:23PM +0100, Lee Jones wrote:
> If a list of widgets is provided and one of them fails to be added as
> a control, the present semantics fail all subsequent widgets. A better
> solution would be to only fail that widget, but pursue in attempting
> to add the rest of the list.

You're posting this *again* without bothering to respond to my review
comments.
