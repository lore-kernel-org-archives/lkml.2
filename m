Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab2GMRXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:23:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2611 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277Ab2GMRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:22:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 13 Jul 2012 10:18:31 -0700
Message-ID: <500057A0.1050108@nvidia.com>
Date: Fri, 13 Jul 2012 22:45:12 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] regulator: tps6586x: add support for input supply
References: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com> <1342187432-18668-3-git-send-email-ldewangan@nvidia.com> <20120713142229.GM4215@opensource.wolfsonmicro.com>
In-Reply-To: <20120713142229.GM4215@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2012 07:52 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Fri, Jul 13, 2012 at 07:20:32PM +0530, Laxman Dewangan wrote:
>> There is multiple voltage input pins on device which
>> takes the voltage input for different voltage regulator.
>> Support to configure the voltage input supplied by
>> different regulator for each regulators.
> Applied, thanks.
Thanks for care.

I was thinking that 1/2 should also go through your tree to avoid any 
functionality break on existing platform who are using this regulator.
