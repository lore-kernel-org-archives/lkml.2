Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab1CXPuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:50:15 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:39113 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab1CXPuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:50:14 -0400
Date: Thu, 24 Mar 2011 10:49:56 -0500 (CDT)
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
X-X-Sender: ihadzic@umail
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Airlie <airlied@gmail.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
In-Reply-To: <AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
Message-ID: <Pine.GSO.4.62.1103241034180.2327@umail>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
 <1300864998.3522.71.camel@thor.local> <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
 <1300868532.3522.81.camel@thor.local> <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
 <Pine.GSO.4.62.1103230633160.12612@umail> <1300880747.16522.13.camel@thor.local>
 <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
 <Pine.GSO.4.62.1103240628490.1156@umail> <AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Mar 2011, Linus Torvalds wrote:

>
> In other words: Why should I pull this at all?
>

You should pull it (eventually) because it fixes a problem that is real 
and visible and does it in a way that is conservative enough to not risk 
introducing new breakage.

Whether you should pull it now or wait until you get convinced that we 
got our act together is totally your call.

Speaking as the author of the patch, what Dave pushed this morning is good 
enough for me. I spent quite a bit of time testing all the usage patterns 
(including the latest version pushed to you) and I can assert that the 
change is safe.

I can't speak for others, but I have not seen any additional complaints.

-- Ilija

