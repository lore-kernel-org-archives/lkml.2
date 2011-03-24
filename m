Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834Ab1CXTLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:11:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33787 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813Ab1CXTLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pa3uzGiBiojOVDjDRq6EhTJsFbm5cItAftArSSZhAVpJmxoKjFBsrS2vHIYJe66DH6
         TIgIioeQ+Ferk647JICD7ETULPziSVyCjgEaxIV2IbZeHde/d1YCCn6AiWLIHyvr56Lf
         tr0ZkbONLCWaOdoIjLe9c256h7rD0/2ZoEJdk=
MIME-Version: 1.0
In-Reply-To: <Pine.GSO.4.62.1103241034180.2327@umail>
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
	<Pine.GSO.4.62.1103241034180.2327@umail>
Date: Thu, 24 Mar 2011 12:11:03 -0700
Message-ID: <AANLkTinM3-wWiH++cr=8_45Czv23FB2SURrFv3F8-7of@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Corbin Simpson <mostawesomedude@gmail.com>
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 8:49 AM, Ilija Hadzic
<ihadzic@research.bell-labs.com> wrote:
>
>
> On Thu, 24 Mar 2011, Linus Torvalds wrote:
>
>>
>> In other words: Why should I pull this at all?
>>
>
> You should pull it (eventually) because it fixes a problem that is real and
> visible and does it in a way that is conservative enough to not risk
> introducing new breakage.
>
> Whether you should pull it now or wait until you get convinced that we got
> our act together is totally your call.
>
> Speaking as the author of the patch, what Dave pushed this morning is good
> enough for me. I spent quite a bit of time testing all the usage patterns
> (including the latest version pushed to you) and I can assert that the
> change is safe.
>
> I can't speak for others, but I have not seen any additional complaints.

Alternatively, kick it out and wait for Ilija to see and address
Michel's complaints. It's not too late to improve this.

~ C.

-- 
When the facts change, I change my mind. What do you do, sir? ~ Keynes

Corbin Simpson
<MostAwesomeDude@gmail.com>
