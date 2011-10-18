Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab1JRJvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:51:18 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:55980
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753973Ab1JRJvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:51:16 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dK1432N98dKzz1202hzzz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LT9A1C-02-35G-02
X-M-MSG: 
Message-ID: <4E9D4BB1.6070207@amd.com>
Date: Tue, 18 Oct 2011 11:49:37 +0200
From: Christoph Egger <Christoph.Egger@amd.com>
User-Agent: Mozilla/5.0 (X11; U; NetBSD amd64; en-US; rv:1.9.2.17) Gecko/20110523 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: [PATCH 0/3] x86/microcode: support for microcode
 update in Xen dom0
References: <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com> <4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab> <20111012204048.GA22260@phenom.oracle.com> <4E960746.90805@zytor.com> <20111012214013.GD28723@aftab> <4E9D3F36.6070201@amd.com> <20111018093534.GA17076@aftab>
In-Reply-To: <20111018093534.GA17076@aftab>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 11:35, Borislav Petkov wrote:
> On Tue, Oct 18, 2011 at 04:56:22AM -0400, Christoph Egger wrote:
>> I think this approach is good to get the microcode applied as
>> early as possible at boot time. But on servers you usually do not want
>> to reboot the machine unless you do a BIOS update which will apply
>> the new microcode anyway. So for applying the microcode update
>> at runtime I would like to keep the existing API.
>
> No, you don't want to keep the existing API and you know it. I've
> explained to you last week why.
>

By "existing API" I mean the xen hypercall. Sorry for the confusion.

Christoph


-- 
---to satisfy European Law for business letters:
Advanced Micro Devices GmbH
Einsteinring 24, 85689 Dornach b. Muenchen
Geschaeftsfuehrer: Alberto Bozzo, Andrew Bowd
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

