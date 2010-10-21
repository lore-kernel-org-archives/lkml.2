Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab0JUVZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:25:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38985 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab0JUVZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:25:01 -0400
Message-ID: <4CC0AF76.4040008@zytor.com>
Date: Thu, 21 Oct 2010 14:24:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/fpu for v2.6.37
References: <20101021134558.GA5859@elte.hu> <AANLkTi=RKyHLNTq6iomZOXkc6Zw1j9iAgsq8388XmzwN@mail.gmail.com>
In-Reply-To: <AANLkTi=RKyHLNTq6iomZOXkc6Zw1j9iAgsq8388XmzwN@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 01:45 PM, Linus Torvalds wrote:
> On Thu, Oct 21, 2010 at 6:45 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> Please pull the latest x86-fpu-for-linus git tree from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fpu-for-linus
> 
> This conflicted with the CONFIG_AS_FXSAVEQ changes from the asm tree.
> 
> I fixed it up, but I did it only for  the fpu_fxsave() function. I
> suspect that the CONFIG_AS_FXSAVEQ thing should be used for
> fxsave_user() too.
> 

Yes, and fxrestor.  I noticed that last night.  I will send you an
update no later than early next week after I see the patch in your tree
and have had time to test the update.

	-hpa
