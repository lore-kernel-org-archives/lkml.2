Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1GZUke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:40:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59778 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1GZUkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:40:31 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyqf6G2ZByfaTR5ZiKBVDMeiS2bC3r-WsSfc_M0bJViDg@mail.gmail.com>
References: <20110722125934.GA25433@elte.hu>
	<CACqU3MW-7_gCqNARdrPA5rZoZGLti+DMvkZsJN40VSDtU+VhpQ@mail.gmail.com>
	<1311679697.24752.28.camel@twins>
	<CACqU3MUghvskv4HrVn+w7rCTki0RkRwQfFUaaysHYOqB6V+q4A@mail.gmail.com>
	<CA+55aFyqf6G2ZByfaTR5ZiKBVDMeiS2bC3r-WsSfc_M0bJViDg@mail.gmail.com>
Date: Tue, 26 Jul 2011 16:40:30 -0400
Message-ID: <CACqU3MVBFatEBkaO0qDR19HXn0Dqn2hp-6pZ2K=rn_SUtNVM=g@mail.gmail.com>
Subject: Re: [GIT PULL] core/printk changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        SergeySenozhatsky <sergey.senozhatsky@gmail.com>,
        DaveJones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 26, 2011 at 4:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jul 26, 2011 at 1:12 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>
>> [0]: I still have to find an easy way to transfer patch between gmail
>> and my tree... For now, I ruled out mutt as it mangle the patch...
>
> The gmail web interface on the *receiving* end is easy enough, and I
> do it all the time: just go to the per-email menu in the upper right
> corner of the email, and choose "Show original". Then you just save
> that, and you're done.
>
yes and no. This works locally, but my desktop machine, and my dev
machine are not the same, so I have to do an extra-copy. Moreover,
this gets complicated when working remotely.

I guess the solution I'll ends-up doing is a mix between tagging the
mail in gmail, and retrieving the mbox/maildir through IMAP, but I'd
need a way to tag a single message, not a conversation...

> Sadly, the gmail web interface cannot *send* patches without
> whitespace-mangling them. You have to send them as attachements, and
> there is no way to say "do this attachement inline".
>
> Sad, sad, sad. gmail gets so many other things right, but sending
> patches is a big pain in the *ss for no good reason.
>
> The gmail web client also does threading the wrong way (by subject
> line rather than by following references), but that's apparently what
> Windows people want and are used to because of how Exchange works. Or
> so I've been told - I've never touched that pile of crap. It's sad how
> it has then resulted in crud in gmail. It's not like proper threading
> is some kind of unheard-of feature..
>
agree on most of that :)

It would have been nice if there was a Labs feature to provide
threading the traditional way and to provide a way for inline
attachment. If some people at Google read this message... who knows!

 - Arnaud
