Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2FKTCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:02:20 -0400
Received: from antcom.de ([188.40.178.216]:59554 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab2FKTCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:02:17 -0400
Message-ID: <4FD640B7.90106@antcom.de>
Date: Mon, 11 Jun 2012 21:02:15 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH] ARM: Fix dts files w/ status property: "disable" -> "disabled"
References: <1339427460-23007-1-git-send-email-stigge@antcom.de> <4FD62B2A.2030600@wwwdotorg.org>
In-Reply-To: <4FD62B2A.2030600@wwwdotorg.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 19:30, Stephen Warren wrote:
> On 06/11/2012 09:11 AM, Roland Stigge wrote:
>> This patches fixes some status = "disable" strings to "disabled", the correct
>> way of disabling nodes in the devicetree.
>>
>> lpc32xx.dtsi is fixed separately in the LPC32xx patch set due to the many
>> changes there.
> 
> The Tegra parts,
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> Are you intending this to be applied for 3.5? If so, that's fine. If
> not, splitting it up so I can take the Tegra parts through the Tegra
> tree would reduce the possibility of conflicts.

I would only put it into v3.6. Everything works fine without it (as Arnd
described), it just confused amateurs like me. :-)

Therefore, splitting it up.

Thanks,

Roland
