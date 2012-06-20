Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab2FTSwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:52:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57670 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab2FTSwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:52:32 -0400
Message-ID: <4FE21BEC.6090308@wwwdotorg.org>
Date: Wed, 20 Jun 2012 12:52:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, lrg@ti.com, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, arnd@arndb.de, linus.walleij@linaro.org,
        lee.jones@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] regulator: dt: add policy to have property "regulator-compatible"
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com> <1340194987-23654-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340194987-23654-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 06:23 AM, Laxman Dewangan wrote:
> Add the policy for regulator DT such that if device have multiple
> regulator and its binding contains a child node that describes each
> regulator then each regulator child node must have the property
> "regulator-compatible" which matches with regulator name of their
> hardware counterparts.
> Modify the DT documentation of regulator devices to reflect this
> policy.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

I'm personally OK with this change as-is, so
Acked-by: Stephen Warren <swarren@wwwdotorg.org>

I suspect Mark may want the wording in regulators.txt modified a little
to allow each regulator binding to choose whether they want the
regulator child nodes identified using the new regulator-compatible
property, or whether they want each instantiated as an actual device,
using regular device instantiation techniques. That could always be a
later patch though, and I'll leave this aspect up to Mark.
