Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1JYQx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:53:57 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:1834 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1JYQxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:53:55 -0400
X-IronPort-AV: E=Sophos;i="4.69,404,1315180800"; 
   d="scan'208";a="8577827"
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20134.59800.835498.929876@mariner.uk.xensource.com>
Date: Tue, 25 Oct 2011 17:53:44 +0100
To: Borislav Petkov <bp@amd64.org>
CC: Christoph Egger <Christoph.Egger@amd.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: [PATCH 0/3] x86/microcode: support for microcode
	update in Xen dom0
Newsgroups: chiark.mail.xen.devel
In-Reply-To: <m2n.s.1RGYF2-136675@chiark.greenend.org.uk>
References: <20111012101615.GA14966@aftab>
	<4E95D9E7.6090304@zytor.com>
	<4E95E7FE.6050302@goop.org>
	<20111012194543.GD14966@aftab>
	<20111012204048.GA22260@phenom.oracle.com>
	<4E960746.90805@zytor.com>
	<20111012214013.GD28723@aftab>
	<4E9D3F36.6070201@amd.com>
	<m2n.s.1RGYF2-136675@chiark.greenend.org.uk>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov writes ("Re: [Xen-devel] Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen dom0"):
> No, you don't want to keep the existing API and you know it. I've
> explained to you last week why.

So should I submit a patchset to remove the existing post-boot
microcode loading from Linux ?

Ian.
