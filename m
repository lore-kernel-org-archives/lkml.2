Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112Ab1CXUFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:05:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35564 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847Ab1CXUFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=j5FO/MakLwfaXME7cTKGl9zmwC+Wn8fL8ia5GkmQ0L8v5s5WgR8/x45aZQh8BNA5vu
         2Dnyqhwqn1EUrZerBckpK7UY6wfLbYxr/HTYe8aAQNLrXoibhtW02uvggRSPdyA1Q6DC
         ramt+/YqoinoYif8UKvCy7CyzQppVQJ8m+T+A=
MIME-Version: 1.0
In-Reply-To: <AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	<1300864998.3522.71.camel@thor.local>
	<AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
	<1300868532.3522.81.camel@thor.local>
	<AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
	<Pine.GSO.4.62.1103230633160.12612@umail>
	<1300880747.16522.13.camel@thor.local>
	<AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
	<Pine.GSO.4.62.1103240628490.1156@umail>
	<AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
Date: Fri, 25 Mar 2011 06:05:04 +1000
Message-ID: <AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 12:37 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 24, 2011 at 4:31 AM, Ilija Hadzic
> <ihadzic@research.bell-labs.com> wrote:
>>
>> OK, I'll update libdrm side to match this change and send the patch later
>> today
>
> Quite frankly, this whole discussion is a clear example of why DRM has
> been problematic.
>
> Why the hell am I getting pushed stuff that is clearly not baked? It's
> the second week of the merge window, the stuff I'm getting should have
> been finalized two weeks ago, not be something that is still being
> discussed and that has API issues.
>
> In other words: Why should I pull this at all?

Linus,

Take a step back, it was an enhancement to a current API, had gotten
reviewed by two people when I merged it and made sense. Michel raised
his concern after that point, so no matter what it was already in a tree
I'd pushed out to public so the only answer when he raised his concern
was to revert or fix it. Its a minor problem. Like I'd have pushed this patch
post merge window, it solves a real problem that Ilija was seeing and
he stepped up
and fixed it, post-merge review is what happened here, and really this
is nothing
compared to say the fallout in the VFS after 2.6.38-rc1.

If you think this has anything to do with Intel's ability to break your hardware
on every merge then you've got your wires crossed.

Dave.
