Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2GaPib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:38:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47932 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376Ab2GaPia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:38:30 -0400
Date: Tue, 31 Jul 2012 16:38:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/5] ASoC: ab8500: Inform SoC Core that we have our own
 I/O arrangements
Message-ID: <20120731153827.GE4468@opensource.wolfsonmicro.com>
References: <1343745944-18418-1-git-send-email-lee.jones@linaro.org>
 <1343745944-18418-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343745944-18418-3-git-send-email-lee.jones@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:45:41PM +0100, Lee Jones wrote:
> If codec->control_data is not populated SoC Core assumes we want to
> use regmap, which fails catastrophically, as we don't have one:

Applied.  If you could do resends at a rate somewhat lower than once per
working day that'd be helpful, especially given the number of large
patch serieses that you're sending right now.
