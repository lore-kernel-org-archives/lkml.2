Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245Ab1CXUWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:22:33 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:44022 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934156Ab1CXUWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:22:30 -0400
Date: Thu, 24 Mar 2011 15:22:15 -0500 (CDT)
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
X-X-Sender: ihadzic@umail
To: Dave Airlie <airlied@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
In-Reply-To: <AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
Message-ID: <Pine.GSO.4.62.1103241509531.9732@umail>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
 <1300864998.3522.71.camel@thor.local> <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
 <1300868532.3522.81.camel@thor.local> <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
 <Pine.GSO.4.62.1103230633160.12612@umail> <1300880747.16522.13.camel@thor.local>
 <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
 <Pine.GSO.4.62.1103240628490.1156@umail> <AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
 <AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Mar 2011, Dave Airlie wrote:

> Michel raised his concern after that point, so no matter what it was 
> already in a tree I'd pushed out to public so the only answer when he 
> raised his concern was to revert or fix it.

Just to be fair to Michel (and prevent any unnecessary "fights" on the 
list, for which I am sure people have had enough by now), the concern in 
question that triggered revision of the API was raised in time, but I 
oversaw it in the pile of other comments I was also trying to address.

I am neither the first nor the last guy to inadvertently drop a review 
comment due to limited "bandwidth", so this should not be made into a big 
deal. Especially, when no damage was done (except for a few extra E-mails 
and a little extra work).

Dave did the follow-up patch to satisfy Michel (thanks!) and I have 
already submitted the user space stuff that matches it, so hopefully
we are all aligned now.

thanks,

Ilija


