Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2HCP1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:27:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52330 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2HCP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:27:39 -0400
Message-ID: <501BEDE7.80305@wwwdotorg.org>
Date: Fri, 03 Aug 2012 09:27:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V2] regulator: tps6586x: add support for SYS rail
References: <1343973596-7700-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1343973596-7700-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 11:59 PM, Laxman Dewangan wrote:
> Device have SYS rail which is always ON. It is system
> power bus. LDO5 and LDO_RTC get powered through this rail
> internally. Add support for this rail and make the
> LDO5/LDO_RTC input supply to "sys".
> Update document accordingly.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>

