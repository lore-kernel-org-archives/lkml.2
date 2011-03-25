Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab1CYKZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:25:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45509 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933837Ab1CYKZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:25:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        b=hZl1ZWbsRrIBvfOw+nBPAN0eUw6nb5309+eYwpyjYXbCm+8vCi2CvyccKA6WLY/1Zo
         SE3JBr4zuyQ5r7eU8dmdPlalPXsFYpmA1QednT3GetFOiEFa+WG/T86dR0+3qPvLcyBu
         T5lSGnIYrlX+AJpD/LfDLwef4SWR75IIk5qcI=
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie> <1300864998.3522.71.camel@thor.local> <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com> <1300868532.3522.81.camel@thor.local> <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com> <Pine.GSO.4.62.1103230633160.12612@umail> <1300880747.16522.13.camel@thor.local> <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com> <Pine.GSO.4.62.1103240628490.1156@umail> <AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com> <AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com> <AANLkTi=x0ZZNfzCpKURXMCaiEncsFNQ2tg1zbARnJjx1@mail.gmail.com> <AANLkTikti-xUYO_S-ipHzXeNsPtwD1kaLuHbGDMMTXev@mail.gmail.com> <AANLkTik1HCrAus2Rv29EK_vGDf9d2m0E=cAuvF6LEQiQ@mail.gmail.com> <AANLkTi=pKTAcbe9x62pQu6dkDFX=zO9r4b_6T0Uo-ay7@mail.gmail.com>
In-Reply-To: <AANLkTi=pKTAcbe9x62pQu6dkDFX=zO9r4b_6T0Uo-ay7@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <9C992DD6-02C7-437C-B78B-13A4282E9AE3@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
X-Mailer: iPhone Mail (8C148)
From: Ben Skeggs <skeggsb@gmail.com>
Subject: Re: [git pull] drm fixes
Date: Fri, 25 Mar 2011 20:25:01 +1000
To: Jerome Glisse <j.glisse@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/03/2011, at 10:55, Jerome Glisse <j.glisse@gmail.com> wrote:

> On Thu, Mar 24, 2011 at 8:17 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Mar 24, 2011 at 5:07 PM, Dave Airlie <airlied@gmail.com> wrote:
>>> 
>>> Like seriously you really think VFS locking rework wasn't under
>>> development or discussion when you merged it? I'm sure Al would have
>>> something to say about it considering the number of times he cursed in
>>> irc about that code after you merged it.
>> 
>> Umm. That code was basically over a year old by the time it was merged.
>> 
>> How old was the code we're talking about now? Seriously?
>> 
>> And your argument that this case is something you'd have pushed even
>> outside the merge window - I think that sounds like more of the same
>> problem. You say it fixes a problem - but does it fix a REGRESSION?
>> 
>> Do you see the difference? Every single commit I get "fixes a
>> problem". But our rules for these things are much stricter than that.
>> 
>>> This isn't even close to the level of the usual type of fuckups you
>>> get in a merge window, it just happens you were cc'ed on the
>>> discusson, otherwise I'm betting you'd never even notice. I'm betting
>>> something much worse landed in this merge window that you should be
>>> giving a fuck about, but this isn't the droid you are lookin for.
>> 
>> Maybe not. But why is it always the DRM tree that has these issues?
>> Why is it that the DRM tree is the one that gets relatively _huge_
>> patches after -rc1 is out?
>> 
>> I really REALLY wish that you graphics people would at some point
>> admit that you guys have a problem. I am hoping that the intel side is
>> being worked on.
>> 
>> Instead, I see what seems to be you being in a hurry, and arguments
>> why uncooked code should be merged even outside the merge window.
>> 
>> Do you see what I'm aiming at here?
>> 
>> If this was a one-time event, we wouldn't be having this discussion.
>> But the DRM tree is one of the BIGGEST issues after the merge window
>> has closed. And it's EVERY SINGLE RELEASE.
>> 
>> Why? Some introspection please. You don't even have to answer me. I
>> ask you to answer that to yourself.
>> 
>>                Linus
> 
> Below are my feeling and likely don't reflect any others people feeling.
> 
> DRM have been trying to play catchup for years, GPU are likely the
> most complex piece of hardware you can find in a computer (from memory
> management, to complex modesetting with all kind of tweaks to the
> utterly crazy 3d engine and everythings that comes with it) Unlike
> others piece of hardware, when it comes to fully use a GPU
> acceleration, there is no common denominator that we would be able to
> put in the kernel (like a tcp stack or filesystem). I am sure very few
> people would like to see a full GL stack into the kernel.
> 
> This results in various non common API that each driver expose to the
> userspace and it's all half cooked, because we have a tendency to
> release early (which is not necessarily wrong in my eyes). If i were
> to do it cleanly for one device i wouldn't freeze the API before i got
> a full fast stack (ie fast GL driver, video decompression, dual GPU,
> efficient power management) this is exactly what nouveau is doing,
> they are in the experimental for good reasons, they have the freedom
> to fix their API and they keep improving it each time their userspace
> progress.
Oh, I wish this were actually the case.  The last time we attempted such a thing we were blasted by Linus.  It does make me wonder at why we're even bothering being in staging.

This is where the binary drivers have a huge advantage, they package all the pieces of their driver together and can modify things as necessary.

Part of me does think such an approach with the open source graphics drivers would be better.  The current model doesn't really fit too well in my opinion.  Though, admittedly, there's different problems to going other ways.

Ben.
> 
> So from my POV either frozen API for DRM is not a good solution (there
> is a reason why closed source driver bundly everythings together
> kernel, GL, ddx, ...) either we should leave in experimental until we
> get our API right which would likely means several years (2-4years as
> a wild guess) given current number of people working on this. That
> would mean that most distribution wouldn't enable the open source
> driver and then open source driver likely wouldn't get enough testing
> (kind of a chicken and egg problem).
> 
> I am not even talking about on dramatic GPU changes in last few years.
> For instance few years ago having a dual screen setup meaned that you
> were king of somethings, or least on the top of the hill. Nowadays
> dual, triple screens or even more, is common setup but some DRM API
> was designed without even thinking that one day there would be more
> than 2 crtc (expectation was likely that there would be flying car by
> then).
> 
> Well this are my feeling, we are just chasing a fast moving target and
> always shooting short on the API and freeze ourself into corner case.
> Maybe we, or just i, are bad at designing API (well not always i do
> believe for instance that the modesetting API we expose is a good
> one).
> 
> Cheers,
> Jerome
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
