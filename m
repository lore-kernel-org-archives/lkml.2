Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1AZA0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:26:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44079 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1AZA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:26:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=II8qPE9XGtaWk10wr6W+RyDYR47Wd8MJMUBZhmhdLRT7A+eLQ3tsN5n0oIGu6cXmDC
         mhmeXc3/FD6QqFynX10Gqnhg5TTod3VBw7QUxiYgqqlKrjJKsiCX7j7s4v5mpIrEAiv9
         xOlYsktUlUa8wBWYiAQ3dVMl9f9G/Qhp652m0=
Message-ID: <4D3F6A28.1000402@pobox.com>
Date: Tue, 25 Jan 2011 19:26:16 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, Mark Lord <kernel@teksavvy.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
References: <20110125134748.GA10051@laptop> <20110125140948.GA26762@elte.hu> <20110125153649.GA11386@laptop> <1295971355.4955.104.camel@mulgrave.site> <20110125170522.GA16285@laptop> <4D3F4A69.7090702@teksavvy.com> <20110125141605.43963105.rdunlap@xenotime.net> <4D3F529D.8060406@pobox.com> <4D3F559C.1050809@zytor.com>
In-Reply-To: <4D3F559C.1050809@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 05:58 PM, H. Peter Anvin wrote:
> "Not perfect" is really not good enough.  You're writing to the disk, so
> it *has* to be perfect.  That means dealing with having shared IDE/AHCI
> device and doing the right thing, and the possibility that the kernel
> has interrupts enabled, yadda yadda.
>
> In the end you end up with something that looks, again, like kexec/kdump.

Oh, quite agreed.  It wasn't an endorsement, just a reference :)

	Jeff



