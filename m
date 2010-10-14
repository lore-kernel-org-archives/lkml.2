Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0JNAlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:41:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49018 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab0JNAla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:41:30 -0400
Message-ID: <4CB651A4.60205@zytor.com>
Date: Wed, 13 Oct 2010 17:41:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Feng Tang <feng.tang@intel.com>
Subject: Re: linux-next: Tree for October 13
References: <20101013154522.7b087a20.sfr@canb.auug.org.au> <20101013173826.f4b911b4.akpm@linux-foundation.org>
In-Reply-To: <20101013173826.f4b911b4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 05:38 PM, Andrew Morton wrote:
> On Wed, 13 Oct 2010 15:45:22 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> I have created today's linux-next tree at
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> 
> In an i386 allmodconfig build, compilation of
> arch/x86/kernel/early_printk_mrst.c is emitting a call to
> __this_fixmap_does_not_exist().  

Will look at it.  Do you happen to have toolchain versions?

	-hpa
