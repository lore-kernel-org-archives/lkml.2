Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab1JMAE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:04:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34855 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1JMAE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:04:27 -0400
Message-ID: <4E962AE6.1060505@zytor.com>
Date: Wed, 12 Oct 2011 17:03:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Borislav Petkov <bp@amd64.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com> <4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab> <20111012204048.GA22260@phenom.oracle.com> <4E960746.90805@zytor.com> <20111012214013.GD28723@aftab> <4E96198F.4030906@zytor.com> <4E962581.2000605@goop.org> <4E9628D4.1000605@zytor.com> <4E962A27.4090509@goop.org>
In-Reply-To: <4E962A27.4090509@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 05:00 PM, Jeremy Fitzhardinge wrote:
>
> Presumably we'd want some way to make all possible microcode files
> available to the hypervisor/kernel so that there's no need to construct
> the bootloader config for a specific CPU vendor (or worse, CPU model).
> So that would need either some way of specifying multiple files, or a
> wrapper which can contain multiple files?
>

I have been thinking a "bundle" format with a per-vendor header followed 
by the microcode in the appropriate format for each vendor.

	-hpa


