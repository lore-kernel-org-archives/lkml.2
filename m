Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1JMJ5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:57:23 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39512 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1JMJ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:57:21 -0400
Date: Thu, 13 Oct 2011 11:57:08 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20111013095708.GA1862@aftab>
References: <4E94E1E5.4070505@goop.org>
 <20111012101615.GA14966@aftab>
 <4E95D9E7.6090304@zytor.com>
 <4E95E7FE.6050302@goop.org>
 <20111012194543.GD14966@aftab>
 <20111012204048.GA22260@phenom.oracle.com>
 <4E960746.90805@zytor.com>
 <20111012214013.GD28723@aftab>
 <4E96198F.4030906@zytor.com>
 <20111013073352.GB501@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013073352.GB501@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 03:33:52AM -0400, Borislav Petkov wrote:
> Bottomline is, extending initrd handling to deal with multiple initrd
> images might turn out to be easier to do than the linked list deal.

Alternatively and IMHO, we could avoid the bootloader enabling by
making the ucode part of the initramfs and pull up some of the
prepare_namespace() work in kernel_init() before smp_init() so that we
can have it ready for when bootstrapping the cores.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
