Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab1JRI6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:58:21 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:19985
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831Ab1JRI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:58:19 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2dK9371K1432N98dKzz1202hzzz32i668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LT97L1-01-1E4-02
X-M-MSG: 
Message-ID: <4E9D3F36.6070201@amd.com>
Date: Tue, 18 Oct 2011 10:56:22 +0200
From: Christoph Egger <Christoph.Egger@amd.com>
User-Agent: Mozilla/5.0 (X11; U; NetBSD amd64; en-US; rv:1.9.2.17) Gecko/20110523 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
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
References: <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com>	<4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab>	<20111012204048.GA22260@phenom.oracle.com>	<4E960746.90805@zytor.com> <20111012214013.GD28723@aftab>	<4E96198F.4030906@zytor
In-Reply-To: <4E9C6886.20600@zytor.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/11 19:40, H. Peter Anvin wrote:
> On 10/17/2011 10:08 AM, Konrad Rzeszutek Wilk wrote:
>>
>> <scratches his head>
>> You are still using the microcode API (the existing one) to
>> program the CPUs right? It is just that you are fetching the images
>> much much earlier than it currently is done?
>>
>
> No, the goal is to ditch the existing API and load the CPUs very early
> in the start path.
>
> 	-hpa

I think this approach is good to get the microcode applied as
early as possible at boot time. But on servers you usually do not want
to reboot the machine unless you do a BIOS update which will apply
the new microcode anyway. So for applying the microcode update
at runtime I would like to keep the existing API.

Christoph

-- 
---to satisfy European Law for business letters:
Advanced Micro Devices GmbH
Einsteinring 24, 85689 Dornach b. Muenchen
Geschaeftsfuehrer: Alberto Bozzo, Andrew Bowd
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

