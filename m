Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2FKWXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:23:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34189 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2FKWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <1339412537-24485-13-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
	<1339412537-24485-13-git-send-email-stigge@antcom.de>
Date: Mon, 11 Jun 2012 19:23:45 -0300
Message-ID: <CAAAP30Gf4+tt3AbqcekqQCmHqS=8-_PVe+69u2tNOoLN6KfAuQ@mail.gmail.com>
Subject: Re: [PATCH 12/14] ARM: LPC32xx: DT conversion of Standard UARTs
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
> This patch switches from static serial driver initialization to devicetree
> configuration. This way, the Standard UARTs of the LPC32xx SoC can be enabled
> individually via DT.
>
> E.g., instead of Kconfig configuration, the phy3250.dts activates
> UARTs 3 and 5.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
