Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab2EDMWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:22:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2EDMWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:22:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 1/1] ARM: tegra: Add Tegra Memory Controller(MC) driver
Date: Fri, 4 May 2012 08:41:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Colin Cross <ccross@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
References: <1336063897-12083-1-git-send-email-hdoyu@nvidia.com> <CAOesGMivxdDhkEoZh=LuvtKRPfgXi=8X4chEL-cJazjgeo_ONA@mail.gmail.com> <20120504083424.0f394a6db8e95763e59ae2a0@nvidia.com>
In-Reply-To: <20120504083424.0f394a6db8e95763e59ae2a0@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205040841.39351.arnd@arndb.de>
X-Provags-ID: V02:K0:r8hTa/nIXPFUsyUUz2IFPRNpPtwLMT0cwxYIRKw/BrV
 2KSV33dqW4pQClbl1c8Ns77olz9D/XlFLZvjLpn1fDtY9V2poW
 gFaLPXPdWfqUEOZRw1Ml3MMJqm77TtH1Rb+BrNjmAIflZYYAdD
 ZxQHc6YW7MLQ8TIvbq6faSLQjmqWSR3nTXhJJWKlJ4Z2m6dTRV
 3SVWYZiAAwhvnRlhbKv8+mECDy38yw2+1i0uoN5t+rtJg9td0F
 i9zdfmtVjMgwxMkBX9omCy9GRuwNC/LGtNcGI9pyfFhDgVdkqo
 C9EEzzsaKPU1roOvLm33KzcgckY0hpyvRcE6GuuhFymo1P0MoI
 T9ZJ+bvnWNr1CaiAZhWQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Hiroshi Doyu wrote:
> > Since tegra has a custom memory controller it's not as obvious that it
> > needs to go in a shared location, indeed. But it's easier to use the
> > same practices across platforms, and if there are other vendors that
> > end up sharing IP blocks for memory down the road, having them in a
> > common location makes sense.
> 
> I think that the above TI's patch is:
> 
>   Add TI EMIF SDRAM controller driver
>     http://lwn.net/Articles/494922/
> 
> I'm moving this Tegra MC driver under drivers/memory, "tegra{20,30}-mc.c".

Ok, very good!

	Arnd
