Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3ABTDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:03:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34521 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3ABTC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:02:57 -0500
Message-ID: <50E4845D.6020809@wwwdotorg.org>
Date: Wed, 02 Jan 2013 12:02:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: tegra: Set SCU base address dynamically from
 DT
References: <1355725087-11363-1-git-send-email-hdoyu@nvidia.com> <1355725087-11363-4-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1355725087-11363-4-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2012 11:18 PM, Hiroshi Doyu wrote:
> Set Snoop Control Unit(SCU) register base address dynamically from DT.

Hiroshi, what's the status on this patch series? I think Rob had
comments/objections on patch 4; are you going to post an updated series,
or is this series replaced by patch 3 in your Tegra114 series?
