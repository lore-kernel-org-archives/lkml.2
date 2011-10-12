Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1JLWfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:35:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34464 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1JLWfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:35:18 -0400
Message-ID: <4E961608.6060802@zytor.com>
Date: Wed, 12 Oct 2011 15:34:48 -0700
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
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com> <4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab> <4E96146C.5070701@goop.org> <4E9614AE.1060508@zytor.com> <4E9615B8.6010507@goop.org>
In-Reply-To: <4E9615B8.6010507@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 03:33 PM, Jeremy Fitzhardinge wrote:
>>
>> Yes, there has.  There is at least one case where we have to print an
>> error message saying "update your BIOS" because our current microcode
>> update is too late.
>
> Is that K8 errata 93 or something else?
>

The one I'm thinking about is an Atom erratum, but it's entirely 
possible there are others.

	-hpa


