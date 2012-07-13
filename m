Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161928Ab2GMFrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:47:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13971 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887Ab2GMFrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:47:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Jul 2012 22:43:01 -0700
Message-ID: <4FFFB6BD.903@nvidia.com>
Date: Fri, 13 Jul 2012 14:48:45 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: Wei Ni <wni@nvidia.com>, "Zhang, Rui" <rui.zhang@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@ger.kernel.org>
Subject: Re: How to use the generic thermal sysfs.
References: <1342088573.27605.101.camel@tegra-chromium-2> <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 07:54 PM, R, Durgadoss wrote:
> We are working on a notification API from any generic sensor driver to
> the thermal framework.
> Please have a look at the 'notify_thermal_framework' API in the patch here:
> http://www.spinics.net/lists/linux-acpi/msg36049.html

At first sight these patches look close to what we need as well. Are you 
considering to support the definitions of thermal zones using the device 
tree? Is there a public git tree where we can pull the latest version of 
this code in order to keep in sync with you guys?

Thanks,
Alex.
