Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2IURG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:06:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55643 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2IURGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:06:25 -0400
Message-ID: <1348247182.11116.245.camel@hornet>
Subject: Re: [PATCH v2] arm: introduce a DTS for Xen unprivileged virtual
 machines
From: Pawel Moll <pawel.moll@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Date: Fri, 21 Sep 2012 18:06:22 +0100
In-Reply-To: <1348156062-11476-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1348156062-11476-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Sep 2012 17:06:22.0760 (UTC) FILETIME=[6D38F280:01CD981B]
X-MC-Unique: 112092118062401301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 16:47 +0100, Stefano Stabellini wrote:
> Given that the xenvm machine is based on vexpress but with an extremely
> limited selection of peripherals (the guest is supposed to use virtual
> devices instead), add "xen,xenvm" to the list of compatible machines in
> mach-vexpress.
> 
> 
> Changes in v2:
> 
> - remove include skeleton;
> - use #address-cells = <2> and #size-cells = <2>;
> - remove the debug bootargs;
> - use memory@80000000 instead of memory;
> - remove the ranges and interrupt-map from the motherboard node;
> - set the machine compatible to "xen,xenvm-4.2", "xen,xenvm";
> - rename the dts file to xenvm-4.2.dts;
> - add "xen,xenvm" to the list of compatible DT strings to mach-vexpress.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/boot/dts/xenvm-4.2.dts      |   64 ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-vexpress/Makefile.boot |    3 +-
>  arch/arm/mach-vexpress/v2m.c         |    1 +
>  3 files changed, 67 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/boot/dts/xenvm-4.2.dts

I'm still not 100% convinced that the DTS is really necessary there, but
as to the v2m.c change:

Acked-by: Pawel Moll <pawel.moll@arm.com>

Cheers!

Pawel


