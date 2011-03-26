Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1CZLny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 07:43:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37868 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab1CZLnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 07:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ji4/GO561wf140Nge57N6HSZDAA+aSjs7R7W0WZv/mAnnhtD8CcNRa3DrpzZwXKKEm
         VKZNO3E16lFSqhHfexdZl5Vb4mKn+qdpPkAq9L6uNG20YRiv2LdsFdsZfotWvpua/zEp
         qtJJU3j366JdtQKeFdZ9fhE7aWSrWq4BvmJtU=
MIME-Version: 1.0
In-Reply-To: <20110325194010.GG22960@elte.hu>
References: <alpine.LFD.2.00.1103251747450.31464@localhost6.localdomain6>
	<20110325194010.GG22960@elte.hu>
Date: Sat, 26 Mar 2011 12:43:52 +0100
Message-ID: <AANLkTimZRRwRQMHn7dtVW-JDqgCxxzLgbtJJUk4b41wW@mail.gmail.com>
Subject: Re: [GIT pull] irq cleanups for .39
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 8:40 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> Linus,
>>
>> Please pull the latest irq-cleanup-for-linus git tree from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-cleanup-for-linus
>>
>> This contains the irq/urgent bits which Ingo asked to pull earlier, so
>> whatever you pull first does not matter.
>>
>> The gpio patches have been acked by Grant.
>>
>> The avr, h8300, xtensa, m32r, um bits is stuff which got ignored by
>> the arch maintainers. Those archs seem to be orphaned.
>>
>> The cleanup is necessary as we really want to get rid of all the
>> deprecated and compat stuff asap.
>
> Note, while the architectures are orphaned, i've done cross-build testing for
> most of these architectures with your changes applies, so the ones that built
> before should still work now.

um really seems to be orphaned. Jeff has never responded to my emails.
As I'm a heavy user of User Mode Linux I keep it alive on my own.

Please send patches which require action on UML to me or CC
user-mode-linux-devel@lists.sourceforge.net so that I can pick up and test them.
I have a testbed for UML.


> Thanks,
>
>        Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Thanks,
//richard
