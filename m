Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2LSOPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:15:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3163 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2LSOPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:15:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 19 Dec 2012 06:15:36 -0800
Message-ID: <50D1CC07.6070506@nvidia.com>
Date: Wed, 19 Dec 2012 19:45:35 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] serial: tegra: add serial driver
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com> <20121217171027.6AE573E0BDD@localhost> <50CF8F36.2030309@wwwdotorg.org> <20121219130151.F29CA3E0AD7@localhost>
In-Reply-To: <20121219130151.F29CA3E0AD7@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 December 2012 06:31 PM, Grant Likely wrote:
> On Mon, 17 Dec 2012 14:31:34 -0700, Stephen Warren<swarren@wwwdotorg.org>  wrote:
>> On 12/17/2012 10:10 AM, Grant Likely wrote:
>>> On Mon, 17 Dec 2012 17:40:49 +0530, Laxman Dewangan<ldewangan@nvidia.com>  wrote:
>>
>> Aren't we still supposed to support platform data so that it can
>> override what's in DT in order to fix up bad DTs? Or, has that
>> requirement been dropped. If it has, we can drop a bunch of code from a
>> variety of Tegra-specific drivers, I expect.
> Do you have an actual user for this? If not, then don't borrow trouble.
> Just drop it. Things like platform_data can always be added later only
> if it is needed.

Currently all our board supports DT. we are not using any driver 
instantiated by board files.
I will remove the platform data for current patch and if it is require 
then will add later with reasoning.

Hope this will be fine with Stephen also so that  this basic patch can 
be included into tree soon.


