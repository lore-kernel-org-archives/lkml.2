Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1CYASe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 20:18:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab1CYASd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 20:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikti-xUYO_S-ipHzXeNsPtwD1kaLuHbGDMMTXev@mail.gmail.com>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
 <1300864998.3522.71.camel@thor.local> <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
 <1300868532.3522.81.camel@thor.local> <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
 <Pine.GSO.4.62.1103230633160.12612@umail> <1300880747.16522.13.camel@thor.local>
 <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
 <Pine.GSO.4.62.1103240628490.1156@umail> <AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
 <AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
 <AANLkTi=x0ZZNfzCpKURXMCaiEncsFNQ2tg1zbARnJjx1@mail.gmail.com> <AANLkTikti-xUYO_S-ipHzXeNsPtwD1kaLuHbGDMMTXev@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Mar 2011 17:17:42 -0700
Message-ID: <AANLkTik1HCrAus2Rv29EK_vGDf9d2m0E=cAuvF6LEQiQ@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@gmail.com>
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 5:07 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> Like seriously you really think VFS locking rework wasn't under
> development or discussion when you merged it? I'm sure Al would have
> something to say about it considering the number of times he cursed in
> irc about that code after you merged it.

Umm. That code was basically over a year old by the time it was merged.

How old was the code we're talking about now? Seriously?

And your argument that this case is something you'd have pushed even
outside the merge window - I think that sounds like more of the same
problem. You say it fixes a problem - but does it fix a REGRESSION?

Do you see the difference? Every single commit I get "fixes a
problem". But our rules for these things are much stricter than that.

> This isn't even close to the level of the usual type of fuckups you
> get in a merge window, it just happens you were cc'ed on the
> discusson, otherwise I'm betting you'd never even notice. I'm betting
> something much worse landed in this merge window that you should be
> giving a fuck about, but this isn't the droid you are lookin for.

Maybe not. But why is it always the DRM tree that has these issues?
Why is it that the DRM tree is the one that gets relatively _huge_
patches after -rc1 is out?

I really REALLY wish that you graphics people would at some point
admit that you guys have a problem. I am hoping that the intel side is
being worked on.

Instead, I see what seems to be you being in a hurry, and arguments
why uncooked code should be merged even outside the merge window.

Do you see what I'm aiming at here?

If this was a one-time event, we wouldn't be having this discussion.
But the DRM tree is one of the BIGGEST issues after the merge window
has closed. And it's EVERY SINGLE RELEASE.

Why? Some introspection please. You don't even have to answer me. I
ask you to answer that to yourself.

                Linus
