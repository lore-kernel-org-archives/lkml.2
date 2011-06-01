Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab1FAPpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:45:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51614 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab1FAPp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:45:29 -0400
Message-ID: <4DE65E70.50302@zytor.com>
Date: Wed, 01 Jun 2011 08:44:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dan Rosenberg <drosenberg@vsecurity.com>, Matthew Garrett <mjg@redhat.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davej@redhat.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, eranian@google.com,
        penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <1306442367.2279.25.camel@dan> <20110531165252.GB8971@srcf.ucam.org> <4DE5360D.5070809@zytor.com> <20110531185122.GA11998@srcf.ucam.org> <1306868609.6317.25.camel@dan> <20110531195551.GC26970@elte.hu> <4DE54C66.10106@zytor.com> <20110531202712.GB28731@elte.hu> <4DE54FFF.4010500@zytor.com> <20110601061843.GA27671@elte.hu>
In-Reply-To: <20110601061843.GA27671@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 11:18 PM, Ingo Molnar wrote:
>>
>> Older boot loaders did not know how big the kernel image was, 
>> therefore had no way to avoid memory space collision.  That is 
>> fixed in boot protocol 2.10.
> 
> But i loaded really large kernel images way back 10 years ago on 
> various systems and never had any problems until the default 
> allyesconfig hit a ~40 MB kernel image size limit ;-)
> 
> (which limit was in the kernel, not in the bootloader)

But it would have depended on the target hardware!  That's the problem.

> 
> So yes, a large kernel image "can" be an issue with old bootloaders 
> in some situations on weird machines but we don't really "break" them 
> via randomization, they were broken and fragile in some situations to 
> begin with.
> 

Well, yes; and I don't think the randomization. is a signifiant problem.

> It's fixed in any distro that cares and which would use our (not even 
> released) kernel that might one day have randomization.
> 
> Is that a fair summary of the bootloader situation?

No, because I don't think Grub is fixed in any of its flavors.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

