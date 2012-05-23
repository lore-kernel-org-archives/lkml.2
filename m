Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2EWXrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:47:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36588 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2EWXrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:47:51 -0400
Message-ID: <4FBD7724.1050503@garzik.org>
Date: Wed, 23 May 2012 19:47:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 3.5
References: <20120523192826.GA4447@havoc.gtf.org> <CA+55aFyTDK50z7sCfRD_nzAKmWpjABxRx1f=j8i9jUUXNgHjzg@mail.gmail.com> <4FBD5826.3070004@garzik.org> <CA+55aFwb-cMTuEFaOW=zwLyk_J8eeLkUs-D0DRO7r-9t7k5crQ@mail.gmail.com>
In-Reply-To: <CA+55aFwb-cMTuEFaOW=zwLyk_J8eeLkUs-D0DRO7r-9t7k5crQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 06:28 PM, Linus Torvalds wrote:
> On Wed, May 23, 2012 at 2:35 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>>
>> hmmm, can you try again?  The output of
>>
>> http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=summary
>>
>> and
>>
>> http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=tag;h=4560c1c455fb87ba3013967d6ed5d0b1d18cc109
>>
>> looks correct, so I think there was a mirroring delay.
>
> No. Look closers.
>
> You've created a tag called "tag/upstream-linus", and that's the one
> you asked me to pull.
>
> But looking at gitweb, there is *also* a tag called just
> "upstream-linus", and that's the one you probably *meant* me to pull.
>
> If you had asked me to pull "tags/upstream-linus" (note: "tags/" vs
> "tag/"), that would have indicated that it's in the "tags" namespace
> and I would have gotten the one you meant.
>
> I'd suggest you delete the old confused "tag/upstream-linus" tag (aka
> "tags/tag/upstream-linus").

Bogus tag/upstream-linus deleted, and push script updated.  This is the 
head of the new output:

Please pull 2fff27512600f9ad91335577e485a8552edb0abf from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git 
tags/upstream-linus

