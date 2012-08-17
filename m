Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2HQTGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:06:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45596 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2HQTFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:05:45 -0400
Message-ID: <502E9604.4010701@wwwdotorg.org>
Date: Fri, 17 Aug 2012 13:05:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk
CC: Bill Huang <bilhuang@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, ldewangan@nvidia.com,
        thierry.reding@avionic-design.de, xxie@nvidia.com, jhovold@gmail.com,
        kyle.manna@fuel7.com, rklein@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: dt: tps6586x: Add power off control
References: <1345194989-11614-1-git-send-email-bilhuang@nvidia.com> <1345194989-11614-2-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1345194989-11614-2-git-send-email-bilhuang@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 03:16 AM, Bill Huang wrote:
> Add DT property "ti,system-power-controller" telling whether or not this
> pmic is in charge of controlling the system power, so the power off
> routine can be hooked up to system call "pm_power_off".
> 
> Based on the work by:
> Dan Willemsen <dwillemsen@nvidia.com>
> 
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>

Tested-by: Stephen Warren <swarren@wwwdotorg.org>

Note that this conflicts (only context in tps6586x.txt I think) with
commit b93fffb "regulator: tps6586x: add support for SYS rail" in the
regulator tree. Also note that the patch is based on linux-next, which
contains a mis-merge of tps6586x.txt from the regulator tree. In other
words, expect some slight conflicts when you apply this. Taking it
through the regulator tree would eliminate them.
