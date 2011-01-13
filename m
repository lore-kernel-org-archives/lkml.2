Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab1AMDWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:22:35 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64548 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab1AMDWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:22:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q8MqueIYMuVeWpLwQseZfIB2+MOIMz/4W9uN2Cwj2TY5rjZOmI8Hc1fTQ6rLGsbrjM
         mvNB9B6/BAvzctItI6aI7BQBb27QkGLYZAPq2VZ+0sk0daYTwK7GgNBgLfsA0coXlldQ
         98zrlsikzX7vrHPIMVb23oA5nGbrws15Mhd6w=
MIME-Version: 1.0
In-Reply-To: <1294888828.2757.30.camel@perseus>
References: <20110107075831.GA14915@amd>
	<1294763679.2435.72.camel@doink>
	<AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	<1294768668.2435.177.camel@doink>
	<1294804776.2821.4.camel@perseus>
	<AANLkTim8rQb3mDFHg7DmbTZa20FxRGk3wJCjOkz=JG9S@mail.gmail.com>
	<1294807279.2821.9.camel@perseus>
	<1294809426.2821.20.camel@perseus>
	<AANLkTikYErmu6bNz51iPgjzdOoa8uWNNdn01texihqM6@mail.gmail.com>
	<1294883313.2757.5.camel@perseus>
	<AANLkTin9ac1r_Hur4w=cxkCg2Z-JVYRCwsR6KeZ+9b=R@mail.gmail.com>
	<1294888828.2757.30.camel@perseus>
Date: Thu, 13 Jan 2011 14:22:30 +1100
Message-ID: <AANLkTimgWNkQhZPSysAC+HkdEk7YH4GHj+TH1SO_Diiy@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
From: Nick Piggin <npiggin@gmail.com>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, aelder@sgi.com,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 2:20 PM, Ian Kent <raven@themaw.net> wrote:
> On Thu, 2011-01-13 at 13:14 +1100, Nick Piggin wrote:
>> On Thu, Jan 13, 2011 at 12:48 PM, Ian Kent <raven@themaw.net> wrote:
>> > On Thu, 2011-01-13 at 12:01 +1100, Nick Piggin wrote:
>> >> Hm, what are the concurrencies that you need protection from?
>> >
>> > Ha, I think I'm wrong about this, after looking more closely at this I'm
>> > struggling to see why autofs4_lock is needed at all.
>>
>> Well you did send me a series of patches to remove it, but
>> unfortunately that was just as you made some larger changes
>> to autofs4 upstream and I wasn't able to keep them up to date.
>>
>> It would be much appreciated if you had time to take another
>> look at all the locking and streamline it.
>
> I have started looking at it but just the autofs4_lock.
>
> As you know, we have some significant autofs changes in progress, so I
> don't want to spend a huge amount of time testing (and the testing does
> take a long time) against source that will be very different. So far I
> can't see that the autofs4_lock will introduce any problem so I want to
> leave it for now and (probably) eliminate it in the new code since that
> will need changes as well and will need to be re-tested.

Fair enough.


> I'd appreciate it if you could find time to reply to David's questions
> about the changes to our d_automount patch series. Although, based on
> our previous discussion, I think he has it about right, but a word or
> two from you would be really helpful.

Yes I am meaning to take a look, I'm a bit busy for the next week,
however.
