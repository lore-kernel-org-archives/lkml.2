Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2FKRaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:30:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38967 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab2FKRaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:30:21 -0400
Message-ID: <4FD62B2A.2030600@wwwdotorg.org>
Date: Mon, 11 Jun 2012 11:30:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH] ARM: Fix dts files w/ status property: "disable" -> "disabled"
References: <1339427460-23007-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1339427460-23007-1-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 09:11 AM, Roland Stigge wrote:
> This patches fixes some status = "disable" strings to "disabled", the correct
> way of disabling nodes in the devicetree.
> 
> lpc32xx.dtsi is fixed separately in the LPC32xx patch set due to the many
> changes there.

The Tegra parts,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Are you intending this to be applied for 3.5? If so, that's fine. If
not, splitting it up so I can take the Tegra parts through the Tegra
tree would reduce the possibility of conflicts.
