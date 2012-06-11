Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2FKWUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:20:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47250 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2FKWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:20:14 -0400
MIME-Version: 1.0
In-Reply-To: <1339412537-24485-6-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
	<1339412537-24485-6-git-send-email-stigge@antcom.de>
Date: Mon, 11 Jun 2012 19:20:13 -0300
Message-ID: <CAAAP30GcHpxEEnO0vqROKwooRaMRudjfW7MD2=40VzJ8HGdQQA@mail.gmail.com>
Subject: Re: [PATCH 5/14] ARM: LPC32xx: Adjust dtsi file for MLC controller configuration
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
> This patch takes into account that the MTD NAND MLC controller needs more
> registers, located actually before the previously allocated memory range,
> already starting at 200a8000 instead of 200b0000.
>
> Further, the interrupt for the controller is configured.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
