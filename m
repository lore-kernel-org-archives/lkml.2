Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab1AUUoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:44:23 -0500
Received: from smtp-out.google.com ([74.125.121.67]:5887 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1AUUoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:44:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pgfchki5byJLNa/VFZwmqkXxEoqX4QBKHk1h9D/lQ6jqulCiqOQnHyWIb7/6E7cz+H
         rwmJMLpn3+i95N4manMA==
MIME-Version: 1.0
In-Reply-To: <1295633882.19880.31.camel@m0nster>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
	<AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
	<1295571359.9236.53.camel@m0nster>
	<1295574085.4096.6.camel@Joe-Laptop>
	<1295575123.9236.54.camel@m0nster>
	<1295576730.4096.24.camel@Joe-Laptop>
	<1295624801.19880.13.camel@m0nster>
	<20110121094827.41818a55@jbarnes-desktop>
	<20110121095658.1ab623fe@jbarnes-desktop>
	<1295632828.19880.22.camel@m0nster>
	<20110121100441.06a94482@jbarnes-desktop>
	<1295633882.19880.31.camel@m0nster>
Date: Fri, 21 Jan 2011 12:44:17 -0800
Message-ID: <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
Subject: Re: [PATCH 0/7] Nexus One Support
From: Dima Zavin <dmitriyz@google.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Really though? Let's look at one of them:

[PATCH 3/7] msm: qsd8x50: add acpuclock code

Please tell me the amount of time it took you to "debug and fix
defects in the code" from the following:
http://android.git.kernel.org/?p=kernel/experimental.git;a=blob;f=arch/arm/mach-msm/acpuclock-qsd8x50.c;h=691acdeaad74c2f29927308b8110af7d4dd5070b;hb=refs/heads/android-msm-2.6.37-wip

That is basically a squash of 3 commits (one of which was another
squash of ~20 commits during a cleanup which has all the attributions
in the squash). This file's main authors was Brian, Arve, and myself,
with some contributions from Mike, Iliyan, and Haley from HTC. Doing a
quick-and-dirty grep through the history, the contributions break down
as:
      2 Arve Hjønnevåg <arve@android.com>
      6 Brian Swetland <swetland@google.com>
     14 Dima Zavin <dima@android.com>
      2 Haley Teng <Haley_Teng@htc.com>
      1 Iliyan Malchev <malchev@google.com>
      5 Mike Chan <mike@android.com>

Your commit is a:
   git checkout <branch> -- <file> ; git add ; git commit;

--Dima

On Fri, Jan 21, 2011 at 10:18 AM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Fri, 2011-01-21 at 10:04 -0800, Jesse Barnes wrote:
>> On Fri, 21 Jan 2011 10:00:28 -0800
>> Daniel Walker <dwalker@codeaurora.org> wrote:
>>
>> > On Fri, 2011-01-21 at 09:56 -0800, Jesse Barnes wrote:
>> > > On Fri, 21 Jan 2011 09:48:27 -0800
>> > > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> > >
>> > > > On Fri, 21 Jan 2011 07:46:41 -0800
>> > > > Daniel Walker <dwalker@codeaurora.org> wrote:
>> > > > > This isn't what's happening tho. In maintainer land if someone forwards
>> > > > > you a patch then you leave the original author on the patch. They wrote
>> > > > > the patch and your just forwarding it on up the ladder. This isn't the
>> > > > > case with these patches.. I crafted each of the commit I have authorship
>> > > > > on, no one forwarded those commits to me. I'm not taking authorship
>> > > > > credit for any thing I didn't create, although I an giving credit to the
>> > > > > place which gave me the raw material which was Google. From my
>> > > > > experience this is how it's done in Linux ..
>> > > >
>> > > > I don't know why you're even trying to defend this, just admit you were
>> > > > wrong and move on.
>> > > >
>> > > > Trying to claim the author field for these patches for yourself is both
>> > > > misleading and vain.  You did not write the code and are therefore not
>> > > > the author, trying to conflate the author and commit fields in this way
>> > > > is so misguided I thought you must be trolling when I first saw this
>> > > > thread.
>> > > >
>> > > > This is not "how it's done in Linux" at all.  In this case you're
>> > > > trying to act like a maintainer by collecting patches and forwarding
>> > > > them upstream, so you need to preserve authorship and the s-o-b chain.
>> > > > If you want to take responsibility for the code going forward, great,
>> > > > but don't pollute the logs with bogus author fields that imply you
>> > > > wrote the stuff in the first place.
>> > >
>> > > That said, if you did significant work on these before committing them,
>> > > then you're right and I'm wrong.  It *is* fairly common for committers
>> > > to change things; and if the changes are significant enough, they claim
>> > > authorship and note the original author in the changelog.
>> > >
>> > > So if that's the case here, I apologize, but I didn't see that
>> > > explained in any part of the thread I read.
>> >
>> > I did a significant amount of work to create the commits and series. I'm
>> > sorry if that's not clear, but it is in fact true.
>>
>> Changes to the code or just reordering and merging commits?  If the
>> former, then I think Christoph's comment applies, if the latter, I
>> think preserving authorship is still the right thing to do.
>
> I changed both, switching to new kernel API's, clean ups, finding a
> minimum set of code for this support, and debugging that and fixing
> defects in the code. This wasn't a trivial amount of work to create the
> series and commits.
>
> Daniel
>
> --
> Sent by an consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> Forum.
>
>
>
