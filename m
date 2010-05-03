Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0ECT5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:57:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab0ECT5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:57:50 -0400
Message-ID: <4BDF2A73.1010208@redhat.com>
Date: Mon, 03 May 2010 15:56:35 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091210 Fedora/3.0-4.el6 Thunderbird/3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [LKML] [PATCH] Fix NULL pointer for Xen guests
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <20100427165816.GA24707@phenom.dumpdata.com> <4BD71A2D.6050309@redhat.com> <20100427183428.GA15385@phenom.dumpdata.com> <4BD73134.1030308@redhat.com> <20100503191634.GA19699@phenom.dumpdata.com>
In-Reply-To: <20100503191634.GA19699@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/03/2010 03:16 PM, Konrad Rzeszutek Wilk wrote:
>>> OK, so your control domain is RHEL5. Mine is the Jeremy's xen/next one
>>> (2.6.32). Let me try to compile RHEL5 under FC11 - any tricks necessary
>>> to do that?
>>>
>>>        
>> I haven't tried it -- it might work :)
>>
>> Also, did you try booting with maxvcpus>  vcpus as drjones suggested ?
>>      
> Yes. No luck reproducing the crash/panic. I am just not seeing the failure you
> guys are seeing.
>
> Let me build once more 2.6.33 vanilla + CONFIG_DEBUG_MARK_RODATA=n) and check
> this. And also install a vanilla RHEL5 dom0 as it looks impossible to
> compile a 2.6.18-era kernel under FC11.
>    

Let me try reproducing this on FC11 + 2.6.33.

P.

