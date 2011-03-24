Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1CXOiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:38:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227Ab1CXOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.GSO.4.62.1103240628490.1156@umail>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
 <1300864998.3522.71.camel@thor.local> <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
 <1300868532.3522.81.camel@thor.local> <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
 <Pine.GSO.4.62.1103230633160.12612@umail> <1300880747.16522.13.camel@thor.local>
 <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com> <Pine.GSO.4.62.1103240628490.1156@umail>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Mar 2011 07:37:36 -0700
Message-ID: <AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Dave Airlie <airlied@gmail.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 4:31 AM, Ilija Hadzic
<ihadzic@research.bell-labs.com> wrote:
>
> OK, I'll update libdrm side to match this change and send the patch later
> today

Quite frankly, this whole discussion is a clear example of why DRM has
been problematic.

Why the hell am I getting pushed stuff that is clearly not baked? It's
the second week of the merge window, the stuff I'm getting should have
been finalized two weeks ago, not be something that is still being
discussed and that has API issues.

In other words: Why should I pull this at all?

                      Linus
