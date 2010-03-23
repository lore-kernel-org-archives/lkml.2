Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0CWXTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:19:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49659 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0CWXTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:19:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=pvqJkkAXaicbMWQlUTeQdY1xQyzfQgqRyAQxaBFjZJbsWcaQ7Hnql3nNliyM+KFgPC
         I1j08pL/NpkgFtEM2kDY2229UaWnyyWLUy9eHS+z5FlJ8HH0eHs35bTJB8bkQrCHzj2j
         vV9RAum5gtqV7CpHgjbdkjiqMpODO64TEvLbg=
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge regression in performance
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1003231602130.18017@i5.linux-foundation.org>
Date: Wed, 24 Mar 2010 00:19:15 +0100
Cc: Greg KH <greg@kroah.com>, stable@kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Transfer-Encoding: 8BIT
Message-Id: <D5C7B0DA-D29F-4612-A90B-7051CFC04AA4@gmail.com>
References: <bug-15618-10286@https.bugzilla.kernel.org/> <20100323102208.512c16cc.akpm@linux-foundation.org> <20100323173409.GA24845@elte.hu> <alpine.LFD.2.00.1003231037410.18017@i5.linux-foundation.org> <9D040E9A-80F2-468F-A6CD-A4912615CD3F@gmail.com> <alpine.LFD.2.00.1003231253570.18017@i5.linux-foundation.org> <9FC34DA1-D6DD-41E5-8B76-0712A813C549@gmail.com> <alpine.LFD.2.00.1003231602130.18017@i5.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomorrow I will try to patch and check 2.6.33 and see are this patches enough to restore performance or not, because on 2.6.33 kernel performance issue also used to involve somehow crgoup business (and performance was terrible even comparing to broken 2.6.32). If it will not fix 2.6.33, then I will ask to reopen the bug, otherwise I will post to stable@.

Thanks again for help,
Anton.

On Mar 24, 2010, at 12:04 AM, Linus Torvalds wrote:

> 
> 
> On Tue, 23 Mar 2010, Anton Starikov wrote:
>> 
>> I think we got a winner!
>> 
>> Problem seems to be fixed.
>> 
>> Just for record, I used next patches:
>> 
>> 59c33fa7791e9948ba467c2b83e307a0d087ab49
>> 5d0b7235d83eefdafda300656e97d368afcafc9a
>> 1838ef1d782f7527e6defe87e180598622d2d071
>> 4126faf0ab7417fbc6eb99fb0fd407e01e9e9dfe
>> bafaecd11df15ad5b1e598adc7736afcd38ee13d
>> 0d1622d7f526311d87d7da2ee7dd14b73e45d3fc
> 
> Ok. If you have performance numbers for before/after these patches for 
> your actual workload, I'd suggest posting them to stable@kernel.org, and 
> maybe those rwsem fixes will get back-ported.
> 
> The patches are pretty small, and should be fairly safe. So they are 
> certainly stable material.
> 
> 		Linus

