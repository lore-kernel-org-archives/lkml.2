Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0CaOkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:40:17 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:49797 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab0CaOkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:40:13 -0400
X-SpamScore: -38
X-BigFish: VPS-38(zz146fK1432R1a09M98dN936eM1447Rzz1202hzzz32i2a8h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L05I2L-01-PKI-02
X-M-MSG: 
Message-ID: <4BB35EB5.5060402@amd.com>
Date: Wed, 31 Mar 2010 16:39:49 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090329)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: KVM warning about uncertified CPU for SMP for AMD model 2, stepping
 3
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz> <20100331024213.GV20695@one.firstfloor.org> <4BB33C0D.9090808@amd.com> <alpine.LNX.2.00.1003311531000.24576@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1003311531000.24576@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2010 14:39:55.0231 (UTC) FILETIME=[079AAEF0:01CAD0E0]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 31 Mar 2010, Andre Przywara wrote:
>>
>> BTW.: I encourage people to test their KVM guests with "-cpu host" (on newer
>> QEMUs) and send me any crash logs.
> 
> I just quickly checked ...
> 
snip
> [    0.147235]  [<c0528a80>] init_amd+0x249/0x279
> [    0.148011]  [<c0527d74>] identify_cpu+0xc2/0x223
> [    0.149649]  [<c078822d>] identify_boot_cpu+0xa/0x22
> [    0.152010]  [<c07882c8>] check_bugs+0x8/0xd2
> [    0.153573]  [<c0781a05>] start_kernel+0x32e/0x3a9
> 
> But I admit that this isn't the most up-to-date version, so perhaps it's 
> already fixed ...
No, that is something new. I dug out the kernel (SLES 11.1?) and booted 
with my script, it crashed on FMS 16/9/0, so I guess this machine was a 
Magny-Cours, right?
Anyway, many thanks for the report, I will investigate this.

Regards,
Andre.

-- 
Andre Przywara
AMD-OSRC (Dresden)
Tel: x29712

