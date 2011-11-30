Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab1K3LlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:41:05 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:15077 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1K3LlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:41:03 -0500
X-IronPort-AV: E=Sophos;i="4.69,596,1315180800"; 
   d="scan'208";a="9204133"
Date: Wed, 30 Nov 2011 11:41:58 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Anup Patel <anup@brainfault.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>
Subject: Re: [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt extensions
In-Reply-To: <CAAhSdy3F1oUQP=f_Tig4_MnufwPRpNooZYW8_cSTAse7aOaDoA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111301112400.31179@kaball-desktop>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop> <201111292129.20444.arnd@arndb.de> <CAAhSdy3F1oUQP=f_Tig4_MnufwPRpNooZYW8_cSTAse7aOaDoA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011, Anup Patel wrote:
> Hi all,
> 
> I wanted to know how Xen-ARM for A15 will address following concerns:
> 
> - How will Xen-ARM for A15 support legacy guest environment like ARMv5 or ARMv6 ?

It is not our focus at the moment; we are targeting operating systems
that support a modern ARMv7 machine with GIC support. 
That said, it might be possible to run legacy guests in the future,
introducing more emulation to the hypervisor.


> - What if my Cortex-A15 board does not have a GIC with virtualization support ?

We expect most hardware vendors to provide a GIC with virtualization
support. However if they do not, in order to support their boards we'll
have to do more emulation in the hypervisor.
