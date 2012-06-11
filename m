Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2FKWY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:24:56 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54146 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2FKWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:24:55 -0400
MIME-Version: 1.0
In-Reply-To: <1339412537-24485-15-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
	<1339412537-24485-15-git-send-email-stigge@antcom.de>
Date: Mon, 11 Jun 2012 19:24:54 -0300
Message-ID: <CAAAP30FkJPvBFquQmoBFjohzeo-NoOCup8+TGZf+w8FNs1jaJA@mail.gmail.com>
Subject: Re: [PATCH 14/14] ARM: LPC32xx: Remove mach specific ARCH_NR_GPIOS,
 use default
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 8:02 AM, Roland Stigge <stigge@antcom.de> wrote:
> ARCH_NR_GPIOS was defined statically to include exactly all SoC specific GPIOs.
> Now if additional GPIOs need to be added dynamically, e.g. via DT, none are
> available. Removing the mach specific setting, leaving ARCH_NR_GPIOS to the
> default of 256 (currently in include/asm-generic/gpio.h).
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
