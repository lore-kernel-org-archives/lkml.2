Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1CSKI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 06:08:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43222 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1CSKI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 06:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pkGAIoj983wsfDL6q/2dy/AH1pC0cnqExN5vEshy8BaOHtCgMeOvnlqZItT1jjQNVV
         dKd3W61dAYisokNO9zWrsO7q5fAUkwjdTA095CncGvFmK4GMivPzXQCrokDOtDVeFu4A
         EI0lvhIRCI7DGvmfYpYhVlhrkQoP1mJdvCcqA=
MIME-Version: 1.0
In-Reply-To: <20110318193606.GB3440@suse.de>
References: <20110317213822.GA27980@kroah.com>
	<AANLkTikmuQ6bCn9wws9Z83gZXRz2gRRsWd+8Q34DqaFL@mail.gmail.com>
	<20110318193606.GB3440@suse.de>
Date: Sat, 19 Mar 2011 11:08:25 +0100
X-Google-Sender-Auth: 8SmsT71Vcs7EIvjkLmKH-khRU6Y
Message-ID: <AANLkTikZcimgtQrqy_+BZ1rxWEDDi8fFhy5JgB=6JW1F@mail.gmail.com>
Subject: Re: [stable] [000/474] 2.6.33.8-longterm review
From: John Kacur <jkacur@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: mgalbraith@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 8:36 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Mar 18, 2011 at 10:21:54AM +0100, John Kacur wrote:
>> On Thu, Mar 17, 2011 at 10:38 PM, Greg KH <gregkh@suse.de> wrote:
>> > Yeah, I know what you are thinking, "What, 2.6.33, are you crazy?"
>> >
>> > I'd prefer it if you didn't answer that question...
>> >
>> > Anyway, yes, a .33 kernel release, strange isn't it.
>> >
>> > Turns out there are a lot of people "stuck" on the 2.6.33 kernel series
>> > for a variety of valid reasons, not the least being the Real Time
>> > patchset.  So, in the copious spare time I have, I've been trying to
>> > keep up with the patches that have been applied to the different
>> > longterm and stable kernel trees and have been queueing them up for .33
>> > as well.
>> >
>> > Here's the result of that.  A 474 patch series that is bigger than most
>> > people ever want to review, or see in their inboxes.  Because of that,
>> > it is ONLY being sent to the stable-review@kernel.org mailing list.  If
>> > you want to see the individual patches, look at the git tree of the
>> > patch queue, or look at that mailing list.
>> >
>> > So, if you are using .33, please give this patch a test and let me know
>> > if I've messed up anything (hint, I think I did, it's up to you to
>> > figure it out, consider it a test to see if anyone actually cares about
>> > this kernel version.)
>> >
>> > If I missed anything that I should have in here, please let me know.
>> >
>> > Responses should be made by Saturday, March 19, 2011, 21:00:00 UTC.
>> > Anything received after that time might be too late.
>> >
>> > The whole patch series can be found in one patch at:
>> >        kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.33.8-rc1.gz
>> > and the diffstat can be found below.
>> >
>>
>> There is no rc1, so I assume
>> http://kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.33.8.bz2
>> is correct?
>
> Doh, yes, that is correct, I forgot to put -rc in the Makefile, and my
> scripts just picked it up and went from there.  My fault.
>
>> Which git tree do I want to use?
>
> There is no git tree of the expanded tree of patches, just use that
> patch on top of 2.6.33.7 please.
>
> Or you can apply the quilt patchs, all 474 of them, which are included
> in the longterm-2.6.33 queue on git.kernel.org
>

Thanks, actually that was what I was looking for, the git tree of the
quilt patches. Which are easy to script as git commits which makes
techniques like bisection easy.

Thanks
