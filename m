Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2AaRBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 12:01:49 -0500
Received: from mail-yw0-f51.google.com ([209.85.213.51]:45816 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2AaRBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 12:01:47 -0500
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jan 2012 12:01:47 EST
Message-ID: <4F281D36.3080604@redhat.com>
Date: Tue, 31 Jan 2012 17:56:22 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Brian Swetland <swetland@google.com>
Subject: Re: Linux 3.3-1 out - merge window closed
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com> <CADMYwHxhyExw8jzAVT6PEdfXT-vCSLxg_eGbbqCwRNh0q3Q6eQ@mail.gmail.com> <20120123131808.GC23571@ponder.secretlab.ca> <201201231518.26158.arnd@arndb.de> <87y5sydjpb.fsf@rustcorp.com.au>
In-Reply-To: <87y5sydjpb.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 01:32 AM, Rusty Russell wrote:
>> >  >  >
>> >  >  >  * The code is completely self contained, and the only few external
>> >  >  >  places it changes amount to grabbing a new virtio id (which is
>> >  >  >  Acked-by Rusty) and some OMAP init platform code (which is Acked-by
>> >  >  >  Tony). People who aren't explicitly using it won't notice it's there;
>> >  >  >  even its Kconfig entries get selected automatically when relevant
>> >  >  >  (i.e. only on OMAP4 at this point) and would never show up otherwise.
>>  >
>>  >  Hi Linus,
>>  >
>>  >  I'd also like to see this merged.  Rather than going off and inventing
>>  >  something completely new, Ohad has built on the existing virtio
>>  >  infrastructure to implement IPC between CPUs and DSPs running
>>  >  different operating environments.  This is a strong step in the
>>  >  RightDirection(tm) in my opinion and such behaviour should be
>>  >  encouraged.:-)

I didn't see any virtio spec patches for rpmsg, with the result that 
virtio id 7 is being used also by the virtio-scsi patches.  I can 
certainly push virtio-scsi to 8, but perhaps there's something to 
improve on the communication side...

The code for both drivers seems more or less at the same stage ("wait 
for someone to pull", respectively Linus and James Bottomley).

Paolo
