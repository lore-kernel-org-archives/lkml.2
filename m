Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab2IRN54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:57:56 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:3364 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab2IRN5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:57:53 -0400
X-IronPort-AV: E=Sophos;i="4.80,442,1344211200"; 
   d="scan'208";a="14608418"
Date: Tue, 18 Sep 2012 14:57:05 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Arnd Bergmann <arnd@arndb.de>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH v5 00/17] Introduce Xen support on ARM (based on
 3.6-rc5)
In-Reply-To: <201209181234.29557.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1209181450570.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com> <201209181234.29557.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Arnd Bergmann wrote:
> On Monday 17 September 2012, Stefano Stabellini wrote:
> 
> > I am also attaching to this email the dts'es that I am currently using
> > for dom0 and domU: vexpress-v2p-ca15-tc1.dts (that includes
> > vexpress-v2m-rs1-rtsm.dtsi) is the dts used for dom0 and it is passed to
> > Linux by Xen, while vexpress-virt.dts is the dts used for other domUs
> > and it is appended in binary form to the guest kernel image. I am not
> > sure where they are supposed to live yet, so I am just attaching them
> > here so that people can actually try out this series if they want to.
> 
> You can submit the dts files separately so we can include them in
> the arm-soc tree. Pawel Moll is handling vexpress related changes these
> days, so it would be reasonable if he included them in a pull request.

OK, I'll submit them as a patch series separately.


> > The patch series has been rebased on Konrad's stable/for-linus-3.7
> > branch.
> > 
> > Arnd, Russell, what do you think about this series? If you are OK with
> > it, to whom should I submit it?
> 
> I have no objections to your patches from this series. IMHO they should
> be submitted through the Xen tree,
    
Konrad, are you happy to carry this series in your tree?


>but it would be good to have an Ack from Russell.

Indeed
