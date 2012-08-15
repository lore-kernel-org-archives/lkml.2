Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2HOOBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:01:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40884 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754628Ab2HOOBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:01:21 -0400
Date: Wed, 15 Aug 2012 15:01:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, alsa-devel@alsa-project.org
Subject: Re: [PATCH 03/22] ASoC: ab8500: Inform SoC Core that we have our own
 I/O arrangements
Message-ID: <20120815140117.GC13544@opensource.wolfsonmicro.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344527268-5964-4-git-send-email-lee.jones@linaro.org>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:47:29PM +0100, Lee Jones wrote:
> If codec->control_data is not populated SoC Core assumes we want to
> use regmap, which fails catastrophically, as we don't have one:

*Always* submit code against the current code for the subsystem.
