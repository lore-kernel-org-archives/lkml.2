Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387Ab0HLQqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:46:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49325 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0HLQqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=EAsAqGtucCtuhBBz/VNq0P4JhrufArglmYuZXE9iLEqhlZcI1UknfQdsRWI4c8U2u0
         SGego1jsDHEOyEx0apT3bDWxrxr2QZEyKyzAM48cK46ml9Km/h8qMpTQPQ2oohOGCfgH
         FffrIaxehpsxJKkN2bgn0kCapLQamQvV17kFo=
MIME-Version: 1.0
In-Reply-To: <20100812125248.GA2763@thunk.org>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
	<AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
	<20100812125248.GA2763@thunk.org>
Date: Thu, 12 Aug 2010 19:46:03 +0300
Message-ID: <AANLkTin4=qpDWEKLwes_af6mSCW+ED7v-fWzD34JywU1@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 3:52 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Aug 12, 2010 at 03:28:01PM +0300, Felipe Contreras wrote:
>>
>> The question is why are we adding a user-space API that:
>>  1) no user-space beside Android has expresses interest in implementing
>>  2) is dubious whether the benefits are worth the pain for non-Android
>> user-space
>>  3) will become less and less attractive as dynamic PM gets closer to
>> the sweet-spot, and then surpass it
>>  4) Android can keep in a separate tree until it's clear in the linux
>> community that it's useful (if it ever happens)
>
> Do you believe you speak for all of LKML?

No. I'm speaking for myself, and that includes a lot of what people on
LKML have already said.

> Are you willing to tell ZDNet and the Slashdot fanboys that it's OK
> for Suspend blockers to live in a separate tree, and it's not a case
> of OMG!  Google is forking the kernel?

All the Android community had to do is push the drivers *without*
suspend blockers, then the Android kernel wouldn't be so different and
thus wouldn't be considered a fork. AFAIU the kernel side wakelocks
are already in the kernel, so there's no excuse not to merge the
drivers.

Then people would stop blaming Google for forking the kernel.

Nobody from the "media" cares about suspend blockers; they are a small
patch which cannot be considered a fork, more like a hack, like many
other platforms have.

-- 
Felipe Contreras
