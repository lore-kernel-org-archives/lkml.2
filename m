Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab2IMLTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:19:51 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:42738 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab2IMLTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:19:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,416,1344211200"; 
   d="scan'208";a="14517836"
Date: Thu, 13 Sep 2012 12:19:06 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Dave Martin <dave.martin@linaro.org>
CC: Rob Herring <robherring2@gmail.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 06/25] docs: Xen ARM DT bindings
In-Reply-To: <20120913102938.GB2470@linaro.org>
Message-ID: <alpine.DEB.2.02.1209131215360.15568@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com> <1345131377-14713-6-git-send-email-stefano.stabellini@eu.citrix.com> <503BFCD8.5090804@gmail.com> <alpine.DEB.2.02.1208281823270.15568@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1209121849200.15568@kaball.uk.xensource.com> <50514634.3080303@gmail.com> <20120913102938.GB2470@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2012, Dave Martin wrote:
> Do you think it's feasible to standardise on some interoperable ABI for
> kvm and Xen?  This sounds pretty optimistic, but I'm not aware of all
> the technicalities, or what possible third-party hypervisors are out
> there.
> 
> If we could do it, it would be good.  But I have my doubts about the
> feasibility and the benefits.  If different hypervisors are significantly
> imcompatible, then having a common low-level ABI doesn't help all that
> much.

It is not really possible because each hypervisor offers a different set
of hypercalls and has a different calling convention, so there is very
little we can do to unify them.

For example many of the current Xen hypercalls are to deal with the grant
table and event channels, that are Xen specific concepts completely
missing in KVM.
