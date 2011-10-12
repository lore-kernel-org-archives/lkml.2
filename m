Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1JLUXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:23:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33776 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab1JLUXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:23:18 -0400
Message-ID: <4E95F711.2090004@zytor.com>
Date: Wed, 12 Oct 2011 13:22:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Borislav Petkov <bp@amd64.org>, the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com> <4E95E7FE.6050302@goop.org>
In-Reply-To: <4E95E7FE.6050302@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 12:18 PM, Jeremy Fitzhardinge wrote:
> If there were a general shift to "this is how we're going to do
> microcode in the future", then Xen will happily go along for the ride.

It *is* how we want to do microcode in the future.  There is a prototype 
for the Intel hardware side here; we just haven't had time to finalize 
it partly because I got pulled onto the kernel.org situation.

> But for right now, this patch seems like the pragmatic solution.

No.

> I think the real question is where there's something objectionable about
> the patch itself?

"It does something that is slightly broken on real hardware and totally 
broken for a hypervisor and perpetuates it, while still needing enabling?"

	-hpa

