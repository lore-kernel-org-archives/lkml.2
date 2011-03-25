Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1CYAH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 20:07:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64968 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1CYAH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 20:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DvEU2NdLoFH0fUsyPuWiC6OYWJO2ofLGnzM2otQ0etp0G25JnL6jhu2Agnj1hILbfC
         KBfgXk1W8MPHiadQqFcVM247cHZo1Xp6Uha2khU2i24IJcFJkWIpI19CMXgiu8Pvp6Wx
         6rNakB6YD1tKwzhnZRc+ijKL21b4kdN8skv6c=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=x0ZZNfzCpKURXMCaiEncsFNQ2tg1zbARnJjx1@mail.gmail.com>
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
	<AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
	<AANLkTi=x0ZZNfzCpKURXMCaiEncsFNQ2tg1zbARnJjx1@mail.gmail.com>
Date: Fri, 25 Mar 2011 10:07:55 +1000
Message-ID: <AANLkTikti-xUYO_S-ipHzXeNsPtwD1kaLuHbGDMMTXev@mail.gmail.com>
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

On Fri, Mar 25, 2011 at 9:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 24, 2011 at 1:05 PM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> If you think this has anything to do with Intel's ability to break your hardware
>> on every merge then you've got your wires crossed.
>
> No, it's about the fact that I expect to be pushed code that is
> WRITTEN AND TESTED BEFORE THE MERGE WINDOW.
>
> The merge window is not for writing new code. The code that gets
> merged should have been written two weeks ago already. The only new
> code that I want to see are actual regressions.
>
> I have been talking about this for YEARS now. It's not a new issue. I
> hate seeing patches sent to me while they are clearly still being
> discussed and developed. There's something seriously wrong there when
> that happens.

Like seriously you really think VFS locking rework wasn't under
development or discussion when you merged it? I'm sure Al would have
something to say about it considering the number of times he cursed in
irc about that code after you merged it.

Here's the point you are missing. I'd quite happily have pushed this
*outside the merge window* because it solves a real problem with 0
probability of introducing any new problems, so f'ing what if it was
under discussion everything in the kernel is still being discussed and
developed. The ABI change was a minor move of the field to leave a
larger hole for future changes, it wasn't a fucking fanotify syscall.

This isn't even close to the level of the usual type of fuckups you
get in a merge window, it just happens you were cc'ed on the
discusson, otherwise I'm betting you'd never even notice. I'm betting
something much worse landed in this merge window that you should be
giving a fuck about, but this isn't the droid you are lookin for.

Dave.
