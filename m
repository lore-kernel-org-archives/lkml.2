Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2L0Xik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:38:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59500 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab2L0Xih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:38:37 -0500
Message-ID: <50DCDBD3.1020703@zytor.com>
Date: Thu, 27 Dec 2012 15:37:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: kexec@lists.infradead.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, ebiederm@xmission.com,
        maxim.uvarov@oracle.com, andrew.cooper3@citrix.com, jbeulich@suse.com,
        mingo@redhat.com, x86@kernel.org,
        virtualization@lists.linux-foundation.org, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/11] x86/xen: Add i386 kexec/kdump implementation
References: <5698071f-c96c-4891-81d6-a77c4e3b77c2@default>
In-Reply-To: <5698071f-c96c-4891-81d6-a77c4e3b77c2@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 03:23 PM, Daniel Kiper wrote:
>> On 12/26/2012 06:18 PM, Daniel Kiper wrote:
>>> Add i386 kexec/kdump implementation.
>>>
>>> v2 - suggestions/fixes:
>>>      - allocate transition page table pages below 4 GiB
>>>        (suggested by Jan Beulich).
>>
>> Why?
>
> Sadly all addresses are passed via unsigned long
> variable to kexec hypercall.
>

So can you unf*ck your broken interface before imposing it on anyone else?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

