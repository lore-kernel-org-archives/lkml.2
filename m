Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2JQHPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:15:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10772 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2JQHPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:15:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 17 Oct 2012 00:04:05 -0700
Message-ID: <507E5B15.8040107@nvidia.com>
Date: Wed, 17 Oct 2012 15:15:33 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>, "R, Durgadoss" <durgadoss.r@intel.com>,
        "Brown, Len" <len.brown@intel.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@ger.kernel.org>,
        Alex Courbot <acourbot@nvidia.com>
Subject: How can I get the latest generic thermal framework
References: <1342088573.27605.101.camel@tegra-chromium-2>  <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>  <1342144273.1682.237.camel@rui.sh.intel.com>  <1342164616.27605.129.camel@tegra-chromium-2> <1342165278.1682.259.camel@rui.sh.intel.com>
In-Reply-To: <1342165278.1682.259.camel@rui.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all
Several months ago, I tried to use the generic thermal framework to work 
with the lm90 driver on our SOC, but this work was not completed, and it 
was pended.
Now I want to start it again. I noticed that many new patches of this 
framework were submitted, I checked linux-next.git, but it seems they 
were not merged.
How can I get the latest codes for this thermal framework? which git 
repository should I use?

Thanks.
Wei.
