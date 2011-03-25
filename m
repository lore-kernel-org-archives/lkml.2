Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1CYHvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:51:10 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45557 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1CYHvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x5b07h7q62ue59G0jLMkwpg5IMBIA/IiPyquNv4oDkj6jp2DQTqN3Bn933Uzr7rT6M
         8qacvtHyObNeAB0c9X/StwVOOkD8XOBNa8ziDPnnlwlYmE/mNYUJMWKtxHSiztIXlKS9
         10RIFo6QyANIW3PjYtkBTH+ZRkc04RiFppuLc=
MIME-Version: 1.0
In-Reply-To: <1301039010.12159.56.camel@thor.local>
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
	<AANLkTikti-xUYO_S-ipHzXeNsPtwD1kaLuHbGDMMTXev@mail.gmail.com>
	<AANLkTik1HCrAus2Rv29EK_vGDf9d2m0E=cAuvF6LEQiQ@mail.gmail.com>
	<AANLkTim4jYfAFHkaHAWRU2uAzgRJLP1p1=5dugZgYkhS@mail.gmail.com>
	<1301039010.12159.56.camel@thor.local>
Date: Fri, 25 Mar 2011 17:51:05 +1000
Message-ID: <AANLkTik=+Vy_9_m6WQXePNn2P8c4dezOU4LSEDtj=PaU@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/25 Michel Dänzer <michel@daenzer.net>:
> On Fre, 2011-03-25 at 17:21 +1000, Dave Airlie wrote:
>> On Fri, Mar 25, 2011 at 10:17 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> > On Thu, Mar 24, 2011 at 5:07 PM, Dave Airlie <airlied@gmail.com> wrote:
>> >>
>> >> Like seriously you really think VFS locking rework wasn't under
>> >> development or discussion when you merged it? I'm sure Al would have
>> >> something to say about it considering the number of times he cursed in
>> >> irc about that code after you merged it.
>> >
>> > Umm. That code was basically over a year old by the time it was merged.
>> >
>> > How old was the code we're talking about now? Seriously?
>>
>> It was 30 lines of clean code, that really was fine to be merged in
>> its first form it was merely a future maintaince issue to clean up the
>> interface before it was released as stable.
>
> From my POV the real failure here was that the change made it to *any*
> tree while there were outstanding review issues from when it was
> initially discussed a few weeks earlier. Then when the change was
> submitted — more or less unchanged — I was on my birthday weekend
> enjoying some time away from computers, and when I had caught up with
> things, it was already in drm-next.

Thats the problem really I read all the discussion and there wasn't
much that seemed bad, I think the problem with your suggestions was
there was a lot of latitude to disagree with them and I read the
comments and disagreed with them as well, and it fixed the problem so
I decided it should be pushed or we'd end up waiting another 6 months
to fix it for the people who it actually affects. This isn't the
message that I'd like to send to people who get off their arses and
fix our fuckups.

>
>
>> In this case, if you had a >2 monitor setup connected to an evergreen
>> card, and you tried to do 3D on the 3rd monitor it would just hang the
>> app in a loop forever, the fix needs 3 pieces, one in the kernel, and
>> two userspace fixes.
>
> Actually, the hangs could be fixed in the X driver alone, but the author
> seems uninterested in contemplating that. Maybe because he seems to
> think it's easier to get the kernel fix to users, but I'm with you on
> that it's quite clearly the opposite.

I can't see how you can actually fix the hangs in userspace, you can
hack around the hangs so the user just gets a less useful behaviour
and make maintaining the userspace hack forever, or you can fix the
insufficient kernel interface and get it out quick. I'm not really
into the whole put a userspace hack in and maintain it for years thing
either, and I'd rather nobody else ever decided it was a good idea.

Dave.
