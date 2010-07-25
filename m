Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0GYIIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:08:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43196 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0GYIII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:08:08 -0400
Message-ID: <4C4BF0D2.1070503@zytor.com>
Date: Sun, 25 Jul 2010 01:07:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, jeff@garzik.org,
        ben.collins@ubuntu.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, hmh@debian.org
Subject: Re: support for drives larger than 2TiB
References: <4C4AB952.9030705@kernel.org> <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl> <4C4BEF61.5010203@kernel.org>
In-Reply-To: <4C4BEF61.5010203@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2010 01:01 AM, Tejun Heo wrote:
> (cc'ing hpa, hi!)
> Hello,
> 
> On 07/24/2010 08:40 PM, Yuhong Bao wrote:
>>> However, 2TiB limit is
>>> inherent in the BIOS programming interface and currently the only way
>>> to overcome it is using a completely different BIOS interface (EFI,
>>> that is).
>>
>> Nope, look at the Int13 extensions, it already support 64-bit LBA.
> 
> Ah, yeah, that sounds much more logical than requiring transition to
> EFI.  Does anyone know how wide spread the support for this extension
> is in BIOSes?  Do the bootloaders support this?
> 
> Thanks.
> 

Syslinux 4 supports it with full 64-bit capabilities.  SeaBIOS (used in
Qemu/KVM) supports it, and I know at least some hardware/firmware RAID
solutions support it; I recently got access to a 3 TB SATA drive but due
to NDA requirements I can't reveal the results of that testing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

