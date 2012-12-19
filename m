Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2LSQYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:24:19 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48176 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2LSQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:24:13 -0500
Message-ID: <50D1EA28.2000807@wwwdotorg.org>
Date: Wed, 19 Dec 2012 09:24:08 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: Fix export of of_find_matching_node_and_match()
References: <1355914716-19469-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1355914716-19469-1-git-send-email-grant.likely@secretlab.ca>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 03:58 AM, Grant Likely wrote:
> Commit 50c8af4cf9, "of: introduce for_each_matching_node_and_match()"
> renamed of_find_matching_node() to of_find_matching_node_and_match() and
> created a new static inline of_find_matching_node() wrapper around the
> new name. However, the change neglected to change the EXPORT_SYMBOL()
> reference causing build errors for modules.
> 
> This patch fixes the EXPORT_SYMBOL() statement. Discovered on a PowerPC
> Efika build with the mpc52xx_uart driver being built as a module.

Oops. The patch is obviously correct,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

I guess none of the ARM defconfigs enable any module that uses this,
since I have built all of them multiple times recently:-(
