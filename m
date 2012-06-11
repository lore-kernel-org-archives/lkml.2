Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab2FKUIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:08:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42579 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2FKUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:08:43 -0400
Message-ID: <4FD65047.1060401@wwwdotorg.org>
Date: Mon, 11 Jun 2012 14:08:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        robherring2@gmail.com
Subject: Re: [PATCH] ARM: tegra: Fix dts files w/ status property: "disable"
 -> "disabled"
References: <1339441785-14641-1-git-send-email-stigge@antcom.de> <1339441785-14641-2-git-send-email-stigge@antcom.de>
In-Reply-To: <1339441785-14641-2-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 01:09 PM, Roland Stigge wrote:
> This patches fixes some status = "disable" strings to "disabled", the correct
> way of disabling nodes in the devicetree.
> 
> Just the tegra part here. Everything else goes via other patches and trees.

Thanks. Applied to Tegra's for-next.
