Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab2FTSsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:48:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35464 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2FTSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:48:45 -0400
Message-ID: <4FE21B09.5000901@wwwdotorg.org>
Date: Wed, 20 Jun 2012 12:48:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, lrg@ti.com, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, arnd@arndb.de, linus.walleij@linaro.org,
        lee.jones@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/3] ARM: dts: db8500: add property "regulator-compatible"
 regulator node
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com> <1340194987-23654-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340194987-23654-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 06:23 AM, Laxman Dewangan wrote:
> Device's regulator matches their hardware counterparts with the
> property "regulator-compatible" of each child regulator node in
> place of the child node name.
> Add the property "regulator-compatible" for each regulator with
> their hardware counterpart's name.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

This change is correct as far as it goes, so:
Acked-by: Stephen Warren <swarren@wwwdotorg.org>

That said, the DT still should be modified to match the rules of correct
DT formatting. That was a pre-existing issue though, so it's OK if that
doesn't happen in this patch, and I'm happy leaving that to the
maintainers of this file.
