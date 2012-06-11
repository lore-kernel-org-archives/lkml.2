Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab2FKWTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:19:48 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40427 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2FKWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:19:47 -0400
MIME-Version: 1.0
In-Reply-To: <1339412537-24485-4-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
	<1339412537-24485-4-git-send-email-stigge@antcom.de>
Date: Mon, 11 Jun 2012 19:19:46 -0300
Message-ID: <CAAAP30F_kazyVP5GokpG-SGzFRxX7iLuo3eTmO8m9gN4hwDDXA@mail.gmail.com>
Subject: Re: [PATCH 3/14] ARM: LPC32xx: Remove SLC controller initialization
 from platform init
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
> Since we now support two MTD NAND controllers (MLC and SLC) for LPC32xx via DT,
> we don't initialize the SLC controller statically anymore, but do it via the
> clock setup (see previous patch).
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
