Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab1EQXOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:14:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55404 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab1EQXOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:14:03 -0400
Message-ID: <4DD300F5.9070101@zytor.com>
Date: Tue, 17 May 2011 16:12:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] x86, head_32/64.S: Enable SMEP
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com> <1305581685-5144-4-git-send-email-fenghua.yu@intel.com> <20110517021006.GA6732@srcf.ucam.org> <493994B35A117E4F832F97C4719C4C04011505C272@orsmsx505.amr.corp.intel.com>
In-Reply-To: <493994B35A117E4F832F97C4719C4C04011505C272@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 04:08 PM, Yu, Fenghua wrote:
>>
>> Are EFI runtime service pages currently set up appropriately?
> 
> They are not set up yet. efi init is called after this.
> 
> But at this time there is no user space code yet. So there is no SMEP violation chance until later when any user space page table is setup.
> 

Are EFI runtime pages set up with U=0?  I would argue it is a bug if
they aren't, but we want to make sure that there isn't such a bug.

	-hpa
