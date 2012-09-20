Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2ITVaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:30:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20507 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab2ITVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:30:14 -0400
Date: Thu, 20 Sep 2012 17:29:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual
 machines
Message-ID: <20120920212948.GF27312@konrad-lan.dumpdata.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1348135563.11116.94.camel@hornet>
 <20120920111815.GC2117@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920111815.GC2117@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 12:18:15PM +0100, Dave Martin wrote:
> On Thu, Sep 20, 2012 at 11:06:03AM +0100, Pawel Moll wrote:
> > Morning,
> > 
> > On Wed, 2012-09-19 at 18:44 +0100, Stefano Stabellini wrote:
> > > +/dts-v1/;
> > > +
> > > +/include/ "skeleton.dtsi"
> > 
> > Any particular reason to include skeleton? And I think it would be
> > better to use #address-cells = <2> and #size-cells = <2>, to be ready
> > for LPAE addresses...
> > 
> > > +/ {
> > > +	model = "XENVM-4.2";
> > > +	compatible = "xen,xenvm-4.2", "arm,vexpress";
> > > +	interrupt-parent = <&gic>;
> > > +
> > > +	chosen {
> > > +		bootargs = "earlyprintk console=hvc0 root=/dev/xvda init=/sbin/init";

earlyprintk=xen ?
