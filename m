Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2GWUzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:55:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50614 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2GWUy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:54:59 -0400
Message-ID: <500DBA1F.7050605@wwwdotorg.org>
Date: Mon, 23 Jul 2012 14:54:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>, "lrg@ti.com" <lrg@ti.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] regulator: tps6586x: add support for input supply
References: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com> <1342187432-18668-3-git-send-email-ldewangan@nvidia.com> <20120713142229.GM4215@opensource.wolfsonmicro.com> <500057A0.1050108@nvidia.com> <20120715212114.GI4041@opensource.wolfsonmicro.com>
In-Reply-To: <20120715212114.GI4041@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2012 03:21 PM, Mark Brown wrote:
> On Fri, Jul 13, 2012 at 10:45:12PM +0530, Laxman Dewangan wrote:
> 
>> I was thinking that 1/2 should also go through your tree to
>> avoid any functionality break on existing platform who are using
>> this regulator.
> 
> I'd be happy to do that if the ARM people are happy with it; just
> let me know and resend the patch if you want me to apply it.

Patch 2/2 really depends on patch 1/2 to avoid git bisect breakage;
are you able to rebase it to maintain that order when applying it?


