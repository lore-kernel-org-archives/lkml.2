Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab2IROEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:04:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18261 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab2IROEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:04:43 -0400
Date: Tue, 18 Sep 2012 09:53:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>, linux@arm.linux.org.uk
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH v5 00/17] Introduce Xen support on ARM (based on 3.6-rc5)
Message-ID: <20120918135328.GG12053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1209171215490.29232@kaball.uk.xensource.com>
 <201209181234.29557.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209181234.29557.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 12:34:29PM +0000, Arnd Bergmann wrote:
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
>  
> > The patch series has been rebased on Konrad's stable/for-linus-3.7
> > branch.
> > 
> > Arnd, Russell, what do you think about this series? If you are OK with
> > it, to whom should I submit it?
> 
> I have no objections to your patches from this series. IMHO they should
> be submitted through the Xen tree, but it would be good to have an Ack
> from Russell.

OK, I can do that.

How do we get Russell to look at these patches? Bribes? Ship him some
beer/wine to be delievered to his office?
