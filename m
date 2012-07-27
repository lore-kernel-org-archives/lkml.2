Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2G0Q0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:26:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:64520 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2G0Q0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:26:04 -0400
X-IronPort-AV: E=Sophos;i="4.77,668,1336348800"; 
   d="scan'208";a="13739250"
Date: Fri, 27 Jul 2012 17:25:09 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 18/24] xen/arm: compile blkfront and blkback
In-Reply-To: <1343382495.6812.127.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1207271618310.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>  <1343316846-25860-18-git-send-email-stefano.stabellini@eu.citrix.com> <1343382495.6812.127.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Ian Campbell wrote:
> On Thu, 2012-07-26 at 16:34 +0100, Stefano Stabellini wrote:
> > 
> > +#define XEN_IO_PROTO_ABI_ARM        "arm-abi" 
> 
> I wonder if we ought to call this arm-aarch32-abi or something?

So aarch64 has just been renamed to arm64 and you want to rename arm-abi
to aarch32-abi? :-)


> I wonder if we can also take the opportunity to fix the ABI cockup for
> disks on ARM and make the structs the same for both 32 and 64 bit?

I think it should be a separate patch, but I'll try to come up with one
