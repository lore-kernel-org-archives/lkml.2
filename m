Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2FKWXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:23:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34189 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2FKWXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:23:14 -0400
MIME-Version: 1.0
In-Reply-To: <1339412537-24485-11-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
	<1339412537-24485-11-git-send-email-stigge@antcom.de>
Date: Mon, 11 Jun 2012 19:23:13 -0300
Message-ID: <CAAAP30HsYJqBR1DUarL=o+ky5_3666v=bf3SJiO_aMSC_Ho2ag@mail.gmail.com>
Subject: Re: [PATCH 10/14] ARM: LPC32xx: Add MMC controller support
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
> This patch adds support for the MMC controller of the LPC32xx SoC to the
> platform initialization via the pl08x primecell driver. Lacking more complete
> DT support, done via DT auxdata.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
