Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab1FHUrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:47:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27040 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1FHUrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:47:41 -0400
Message-ID: <4DEFDFB5.3030706@kernel.org>
Date: Wed, 08 Jun 2011 13:46:45 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jim Bos <jim876@xs4all.nl>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <20110608192950.GA29235@srcf.ucam.org> <4DEFCF1A.9030400@kernel.org> <20110608193833.GA29855@srcf.ucam.org> <4DEFD220.5040507@kernel.org> <20110608195250.GB30256@srcf.ucam.org> <4DEFD58D.5060402@kernel.org> <20110608200903.GA30694@srcf.ucam.org> <4DEFDA4A.9080500@kernel.org> <20110608203037.GA31052@srcf.ucam.org> <4DEFDD69.7010000@kernel.org> <20110608204244.GA31484@srcf.ucam.org>
In-Reply-To: <20110608204244.GA31484@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DEFDFBC.0072,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 01:42 PM, Matthew Garrett wrote:
> On Wed, Jun 08, 2011 at 01:36:57PM -0700, Yinghai Lu wrote:
> 
>> or just let bootloader to mark those boot services just like run-time services in e820 table or setupdata?
> 
> That was my original approach, but if there's boot services code at the 
> top of RAM it means that max_pfn is wrong and it's difficult to recover 
> the memory.

not all boot services ram.  just those are called by run-time services code.

Yinghai
