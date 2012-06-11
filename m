Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2FKWZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:25:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35650 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2FKWZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:25:36 -0400
MIME-Version: 1.0
In-Reply-To: <1339412537-24485-14-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
	<1339412537-24485-14-git-send-email-stigge@antcom.de>
Date: Mon, 11 Jun 2012 19:25:35 -0300
Message-ID: <CAAAP30F3TyQi_zouCuxGvOXroAxHTgypD1NFZEpadPmjFFYEPA@mail.gmail.com>
Subject: Re: [PATCH 13/14] ARM: LPC32xx: High Speed UART configuration via DT
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
> This patch fixes the DTS files for the High Speed UARTs 1, 2 and 7 of the
> LPC32xx SoC, adjusting the compatible strings, adding interrupts and status
> configuration. On the PHY3250 reference board, UART2 is enabled.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
