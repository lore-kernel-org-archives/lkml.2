Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab1BCSeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:34:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33179 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab1BCSeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:34:04 -0500
Message-ID: <4D4AF4EA.8080505@zytor.com>
Date: Thu, 03 Feb 2011 10:33:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
References: <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org> <4D475DB5.1020300@zytor.com> <4D488EB1.9020803@goop.org> <4D49B5F6.5010606@zytor.com> <20110202205704.GA14752@liondog.tnic> <4D49D0E6.30102@zytor.com> <20110203182550.GB21488@a1.tnic>
In-Reply-To: <20110203182550.GB21488@a1.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 10:25 AM, Borislav Petkov wrote:
>>
>> We already have a mechanism for passing arbitrary blobs -- the linked
>> list -- so we don't have to add a new field at all.
> 
> So, after staring at grub legacy sources a bit, we could load the
> microcode image using the grub module's mechanism:
> 
> kernel /...
> module /boot/microcode.gz type=SETUP_MICROCODE # this is looked at by parse_setup_data()
> 
> and let grub write the pointer into setup_data passed through the kernel
> header.
> 
> This would mean that we need to add support to a bunch of boot loaders
> used currently, no? Or is there an even better way?
> 

We would need to add boot loader support, yes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

