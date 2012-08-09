Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2HIRLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:11:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38168 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2HIRLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:11:02 -0400
Message-ID: <5023EF22.8010206@wwwdotorg.org>
Date: Thu, 09 Aug 2012 11:10:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com
CC: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V3] regulator: tps6586x: add support for SYS rail
References: <1344152518-29378-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344152518-29378-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 01:41 AM, Laxman Dewangan wrote:
> Device have SYS rail which is always ON. It is system
> power bus. LDO5 and LDO_RTC get powered through this rail
> internally. Add support for this rail and make the
> LDO5/LDO_RTC input supply to "sys".
> Update document accordingly.

Sorry to bug people, but is everyone OK with this patch? I'm holding off
checking in the Tegra-side device tree changes that add regulators until
this patch is checked in (or at least approved) to make sure the Tegra
.dts patches don't need any more changes.

Thanks.
