Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab1K3OLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:11:33 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:38392 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab1K3OLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:11:32 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1111301053300.31179@kaball-desktop>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop>
 <201111292129.20444.arnd@arndb.de> <alpine.DEB.2.00.1111301053300.31179@kaball-desktop>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 30 Nov 2011 14:11:10 +0000
X-Google-Sender-Auth: _zyn3ZrIA15MRST2lEiNTiQB5m0
Message-ID: <CAHkRjk48jHO19H04rf8252+v04hk9qSdKBrfYCqJsZyamVhMEw@mail.gmail.com>
Subject: Re: [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt extensions
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 November 2011 11:39, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> A git branch is available here (not ready for submission):
>
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git arm
>
> the branch above is based on git://linux-arm.org/linux-2.6.git arm-lpae,
> even though guests don't really need lpae support to run on Xen.

Indeed, you don't really need LPAE. What you may need though is
generic timers support for A15, it would allow less Hypervisor traps.
For up-to-date architecture patches (well, development tree, not
guaranteed to be stable), I would recommend this (they get into
mainline at some point):

http://git.kernel.org/?p=linux/kernel/git/cmarinas/linux-arm-arch.git;a=summary

Either use master or just cherry-pick the branches that you are interested in.

-- 
Catalin
