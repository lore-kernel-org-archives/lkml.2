Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2GFHsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:48:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35125 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2GFHsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <1341493572-29735-9-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-9-git-send-email-lee.jones@linaro.org>
Date: Fri, 6 Jul 2012 09:23:17 +0200
Message-ID: <CACRpkda6Ocmp=zoc1f4bA1XjyucZf+it8X+a06cwYJ3-9LECtg@mail.gmail.com>
Subject: Re: [PATCH 8/9] ARM: ux500: Clean-up temporary Device Tree enablement helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we remove some of the extra overhead we introduced to make
> DT:ing the Snowball platform easier. Unfortunately we can't
> remove everything. We are forced to leave cpufreq and DMA behind
> until they have been successfully Device Tree enabled.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

The patch is straight-forward but the commit message is confusing.

This just simplifies the code, the last two sentences about leaving
cpufreq and DMA behind you can put in your weekly report or
something :-)

Yours,
Linus Walleij
