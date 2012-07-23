Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2GWUtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:49:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47291 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2GWUtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:49:41 -0400
Message-ID: <500DB8E0.1050100@wwwdotorg.org>
Date: Mon, 23 Jul 2012 14:49:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, ccross@android.com, olof@lixom.net,
        lrg@ti.com, thierry.reding@avionic-design.de,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca
Subject: Re: [PATCH 1/2] ARM: tegra: harmony: add regulator supply name and
 its input supply
References: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com> <1342187432-18668-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1342187432-18668-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 07:50 AM, Laxman Dewangan wrote:
> Name the regulator as per board schematics and adds its
> supply name info in regulator data.
> Add the always on fixed regulator to refer the battery supply.
> 
> Use this fixed regulator for input supply of some of PMIC
> regulator
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Note that this file might well be deleted within the 3.7 development
cycle, since we will presumably get to the point where when booting from
DT, the DT will set up the regulators, and we won't support non-DT
booting any more on Harmony. Still, that should merge without issues, so
I don't think this will be a problem.
