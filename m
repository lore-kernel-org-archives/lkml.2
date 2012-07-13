Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2GMGGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:06:40 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14639 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2GMGGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:06:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 12 Jul 2012 23:06:25 -0700
Message-ID: <4FFFBB51.7010409@nvidia.com>
Date: Fri, 13 Jul 2012 15:08:17 +0900
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
References: <1342088573.27605.101.camel@tegra-chromium-2> <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com> <4FFFB6BD.903@nvidia.com> <4D68720C2E767A4AA6A8796D42C8EB5915392A@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB5915392A@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 13 Jul 2012 02:54:26 PM JST, R, Durgadoss wrote:
> As of now, we are getting the definitions done through the platform layer
> data. Considerations for device tree .. yes.. but I do not have any sample
> implementation..

Maybe we can help with that then, since we are going to need it.

> On the public tree:
> Rui is trying to get a public tree from where we can pull Thermal subsystem
> changes; and submit patches against this tree.
>
> I hope Rui will publish the link very soon :-)

Excellent. Could you keep us posted when this happens?

Thanks!
Alex.
