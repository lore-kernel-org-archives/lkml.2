Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030292Ab2B2J4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:56:13 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:1482 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965547Ab2B2J4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:56:08 -0500
X-IronPort-AV: E=Sophos;i="4.73,501,1325462400"; 
   d="scan'208";a="11003525"
Message-ID: <1330509362.4270.20.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Dave Martin <dave.martin@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 29 Feb 2012 09:56:02 +0000
In-Reply-To: <20120229093436.GA2077@linaro.org>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
	 <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1330360043.8557.302.camel@zakaz.uk.xensource.com>
	 <20120227180355.GB2023@linaro.org>
	 <1330371219.10008.34.camel@dagon.hellion.org.uk>
	 <20120228102040.GB2063@linaro.org>
	 <1330426133.31269.70.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.00.1202281149210.23091@kaball-desktop>
	 <20120229093436.GA2077@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 09:34 +0000, Dave Martin wrote:
> On Tue, Feb 28, 2012 at 12:28:29PM +0000, Stefano Stabellini wrote:

> > I don't have a very strong opinion on which register we should use, but
> > I would like to avoid r7 if it is already actively used by gcc.
> 
> But there is no framepointer for Thumb-2 code (?)

Peter Maydell suggested there was:
> r7 is (used by gcc as) the Thumb frame pointer; I don't know if this
> makes it worth avoiding in this context.

Sounds like it might be a gcc-ism, possibly a non-default option?

Anyway, I think r12 will be fine for our purposes so the point is rather
moot.

Ian.

