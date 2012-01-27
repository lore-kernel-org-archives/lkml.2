Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2A0Jc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:32:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52739 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2A0JcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:32:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Fri, 27 Jan 2012 10:35:58 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Frid <afrid@nvidia.com>, Antti Miettinen <amiettinen@nvidia.com>,
        Diwakar Tundlam <dtundlam@nvidia.com>,
        Scott Williams <scwilliams@nvidia.com>,
        "Yu-Huan Hsu" <yhsu@nvidia.com>, markgross <markgross@thegnar.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <20120127125315.e6e70511badf68c4e760afc3@canb.auug.org.au>
In-Reply-To: <20120127125315.e6e70511badf68c4e760afc3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201201271035.59156.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 27, 2012, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/power/process.c: In function 'thaw_kernel_threads':
> kernel/power/process.c:199:2: error: 'g' undeclared (first use in this function)
> kernel/power/process.c:199:2: note: each undeclared identifier is reported only once for each function it appears in
> kernel/power/process.c:199:2: error: 'p' undeclared (first use in this function)
> 
> Caused by commit 625278ca8016 ("PM / QoS: Simplify PM QoS expansion/merge").
> 
> Clearly never built :-(  At least, not in this form.
> 
> I have used the pm tree from next-20120125 for today.

Sorry for the breakage.

I took a broken version of that patch from my quilt queue by mistake,
should be fixed now.

Thanks,
Rafael
