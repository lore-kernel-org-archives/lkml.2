Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab0GYSyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 14:54:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54464 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab0GYSyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 14:54:09 -0400
Message-ID: <4C4C8841.60206@zytor.com>
Date: Sun, 25 Jul 2010 11:53:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: alex.buell@munted.org.uk
CC: Tejun Heo <tj@kernel.org>, Yuhong Bao <yuhongbao_386@hotmail.com>,
        jeff@garzik.org, ben.collins@ubuntu.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, hmh@debian.org
Subject: Re: support for drives larger than 2TiB
References: <4C4AB952.9030705@kernel.org>	 <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl> <4C4BEF61.5010203@kernel.org>	 <4C4BF0D2.1070503@zytor.com> <1280046384.2139.0.camel@lithium.local.net>
In-Reply-To: <1280046384.2139.0.camel@lithium.local.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2010 01:26 AM, Alex Buell wrote:
> On Sun, 2010-07-25 at 01:07 -0700, H. Peter Anvin wrote:
>>
>> Syslinux 4 supports it with full 64-bit capabilities.  SeaBIOS (used
>> in
>> Qemu/KVM) supports it, and I know at least some hardware/firmware RAID
>> solutions support it; I recently got access to a 3 TB SATA drive but
>> due to NDA requirements I can't reveal the results of that testing. 
> 
> Yes but is it possible to boot from a complete 4k sector with the new
> standards? 

Yes, but currently there are no 4k *logical* sector products on the
market (and $DEITY knows how many BIOSes would handle them correctly.)
The BIOS interfaces should handle them fine, though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
