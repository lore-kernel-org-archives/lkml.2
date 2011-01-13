Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1AMDUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:20:38 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50743 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932524Ab1AMDUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:20:35 -0500
X-Sasl-enc: aOAW7UicVSV8NTAVLTOAKHna2zoGNaA1rvh9YIj4g6nZ 1294888834
Subject: Re: [announce] vfs-scale git tree update
From: Ian Kent <raven@themaw.net>
To: Nick Piggin <npiggin@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, aelder@sgi.com,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTin9ac1r_Hur4w=cxkCg2Z-JVYRCwsR6KeZ+9b=R@mail.gmail.com>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
	 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	 <1294768668.2435.177.camel@doink> <1294804776.2821.4.camel@perseus>
	 <AANLkTim8rQb3mDFHg7DmbTZa20FxRGk3wJCjOkz=JG9S@mail.gmail.com>
	 <1294807279.2821.9.camel@perseus> <1294809426.2821.20.camel@perseus>
	 <AANLkTikYErmu6bNz51iPgjzdOoa8uWNNdn01texihqM6@mail.gmail.com>
	 <1294883313.2757.5.camel@perseus>
	 <AANLkTin9ac1r_Hur4w=cxkCg2Z-JVYRCwsR6KeZ+9b=R@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 11:20:28 +0800
Message-ID: <1294888828.2757.30.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 13:14 +1100, Nick Piggin wrote:
> On Thu, Jan 13, 2011 at 12:48 PM, Ian Kent <raven@themaw.net> wrote:
> > On Thu, 2011-01-13 at 12:01 +1100, Nick Piggin wrote:
> >> Hm, what are the concurrencies that you need protection from?
> >
> > Ha, I think I'm wrong about this, after looking more closely at this I'm
> > struggling to see why autofs4_lock is needed at all.
> 
> Well you did send me a series of patches to remove it, but
> unfortunately that was just as you made some larger changes
> to autofs4 upstream and I wasn't able to keep them up to date.
> 
> It would be much appreciated if you had time to take another
> look at all the locking and streamline it.

I have started looking at it but just the autofs4_lock.

As you know, we have some significant autofs changes in progress, so I
don't want to spend a huge amount of time testing (and the testing does
take a long time) against source that will be very different. So far I
can't see that the autofs4_lock will introduce any problem so I want to
leave it for now and (probably) eliminate it in the new code since that
will need changes as well and will need to be re-tested.

I'd appreciate it if you could find time to reply to David's questions
about the changes to our d_automount patch series. Although, based on
our previous discussion, I think he has it about right, but a word or
two from you would be really helpful.

Ian


