Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2GMGJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:09:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:31106 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab2GMGJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:09:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121867250"
Message-ID: <1342159850.1682.245.camel@rui.sh.intel.com>
Subject: Re: How to use the generic thermal sysfs.
From: Zhang Rui <rui.zhang@intel.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: "R, Durgadoss" <durgadoss.r@intel.com>, Wei Ni <wni@nvidia.com>,
        "Brown, Len" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@ger.kernel.org>
Date: Fri, 13 Jul 2012 14:10:50 +0800
In-Reply-To: <4FFFBB51.7010409@nvidia.com>
References: <1342088573.27605.101.camel@tegra-chromium-2>
	 <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
	 <4FFFB6BD.903@nvidia.com>
	 <4D68720C2E767A4AA6A8796D42C8EB5915392A@BGSMSX101.gar.corp.intel.com>
	 <4FFFBB51.7010409@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 五, 2012-07-13 at 15:08 +0900, Alex Courbot wrote:
> On Fri 13 Jul 2012 02:54:26 PM JST, R, Durgadoss wrote:
> > As of now, we are getting the definitions done through the platform layer
> > data. Considerations for device tree .. yes.. but I do not have any sample
> > implementation..
> 
> Maybe we can help with that then, since we are going to need it.
> 
> > On the public tree:
> > Rui is trying to get a public tree from where we can pull Thermal subsystem
> > changes; and submit patches against this tree.
> >
> > I hope Rui will publish the link very soon :-)
> 
> Excellent. Could you keep us posted when this happens?
> 
sure.
I'm just working on a patch set and I hope to push them to
git.kernel.org by next week.

thanks,
rui

