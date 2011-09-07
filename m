Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1IGBiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 21:38:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439Ab1IGBhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 21:37:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4qTNpHOpr0nC9VyGGg8hCT8OS6F35m_+s=C7QSYLVnMg@mail.gmail.com>
References: <4E649986.5060606@redhat.com> <CA+55aFw+EJr9FhZZnj0re8hyH5+gFesDso2mX+PWck31ivnWYQ@mail.gmail.com>
 <CA+5PVA4qTNpHOpr0nC9VyGGg8hCT8OS6F35m_+s=C7QSYLVnMg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Sep 2011 18:37:02 -0700
Message-ID: <CA+55aFzCtE=cOnvDguDOgfjEV9mXQTYJbSi_CaGcPXWtzvadpw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM fix for 3.1-rc5
To: Josh Boyer <jwboyer@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 6:19 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>
> Maybe asking for some extra warm fuzzies from now on wouldn't be a
> horrible idea as general practice.

I think that realistically we should definitely look at our practices,
but at the same time, I personally do put a lot of trust in "human
relationships".

Often way more than "technical models".

So there is a lot of safety in just a purely human "this looks like
the kind of pull request I expect". A lot of kernel developers write
nice messages explaining the pull, and there may not be a
cryptographic signature in text like that, but there is definitely a
"human signature" that you start to expect.

So one of the reasons I react to the github pulls is that even though
I'm actually pretty damn certain they are all the people they purport
to be, the "expected signature" is kind of missing. That's especially
true with a pull request that has just the minimal technically
required information - that is 99% script-generated to begin with.

Put another way: I'm not necessarily looking for cryptography. A reply
to a personal email of mine (that didn't go out to any mailing list)
is already a *much* stronger sign of identity: the person having
access to their email account. And once I know that yes, that github
repository was really set up by Xyz, then getting a pull request from
that is already much more sane and safe.

                         Linus
