Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1JLPjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:39:13 -0400
Received: from claw.goop.org ([74.207.240.146]:45866 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab1JLPjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:39:12 -0400
Message-ID: <4E95B49F.5060408@goop.org>
Date: Wed, 12 Oct 2011 08:39:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab>
In-Reply-To: <20111012101615.GA14966@aftab>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 03:16 AM, Borislav Petkov wrote:
> On Tue, Oct 11, 2011 at 08:40:05PM -0400, Jeremy Fitzhardinge wrote:
>> Ping?
>>
>> On 09/26/2011 11:17 AM, Jeremy Fitzhardinge wrote:
>>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>
>>> Hi all,
>>>
>>> I'm proposing this for the next merge window v3.2.
>>>
>>> I originally posted this early this year, and it prompted a debate
>>> about what the "proper" way that Linux should do microcode updates,
>>> with the general concensus being "earlier", ideally in the bootloader
>>> (or in the case of Xen, as the hypervisor boots before starting any
>>> domains).  However, as far as I know there has been no progress along
>>> those lines.
> Err,
>
> wait a sec, last time the suggestion was that _because_ xen supports the
> multiboot protocol, implementing an early solution would be even easier
> for you:
>
> http://marc.info/?l=linux-kernel&m=129667641316947&w=2
>
> Why would a xen microcode solution would even be contingent on how
> upstream Linux solves it (and when)?
>
> AFAICT, you want to hand off the microcode image from the bootloader to
> the hypervisor and update ucode there - no need for dom0 changes...

I don't want a Xen-specific solution to this.  If Linux overall moves to
a boot-time microcode loading scheme, then I'm happy to support it.  But
in the meantime, I want a Xen system to Just Work in the same manner as
a non-Xen one, without requiring special support from all the distros.

    J
