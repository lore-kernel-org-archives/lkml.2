Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1JRJfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:35:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53091 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1JRJfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:35:54 -0400
Date: Tue, 18 Oct 2011 11:35:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Christoph Egger <Christoph.Egger@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: [PATCH 0/3] x86/microcode: support for microcode
 update in Xen dom0
Message-ID: <20111018093534.GA17076@aftab>
References: <20111012101615.GA14966@aftab>
 <4E95D9E7.6090304@zytor.com>
 <4E95E7FE.6050302@goop.org>
 <20111012194543.GD14966@aftab>
 <20111012204048.GA22260@phenom.oracle.com>
 <4E960746.90805@zytor.com>
 <20111012214013.GD28723@aftab>
 <4E9D3F36.6070201@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9D3F36.6070201@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 04:56:22AM -0400, Christoph Egger wrote:
> I think this approach is good to get the microcode applied as
> early as possible at boot time. But on servers you usually do not want
> to reboot the machine unless you do a BIOS update which will apply
> the new microcode anyway. So for applying the microcode update
> at runtime I would like to keep the existing API.

No, you don't want to keep the existing API and you know it. I've
explained to you last week why.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
