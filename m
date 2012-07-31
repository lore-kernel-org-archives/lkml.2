Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2GaNxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:53:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48280 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab2GaNxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:53:39 -0400
Date: Tue, 31 Jul 2012 14:53:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 17/19] Documentation: Define the MOP500 Audio Machine
 Driver Device Tree bindings
Message-ID: <20120731135337.GM4468@opensource.wolfsonmicro.com>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
 <1343741953-17828-18-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343741953-17828-18-git-send-email-lee.jones@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 02:39:11PM +0100, Lee Jones wrote:

> +Required properties:
> + - compatible                : "stericsson,snd-soc-mop500"

> +Non-standard properties:
> + - Machine Driver:
> +   - stericsson,cpu-dai      : Phandle to the CPU-side DAI
> +   - stericsson,audio-codec  : Phandle to the Audio CODEC

You should also support the card name property (there's a helper to
parse it, you can define the name of the property though) so apps can
tell what board they're on.
