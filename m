Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab1CXXtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:49:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757309Ab1CXXtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
 <1300864998.3522.71.camel@thor.local> <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
 <1300868532.3522.81.camel@thor.local> <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
 <Pine.GSO.4.62.1103230633160.12612@umail> <1300880747.16522.13.camel@thor.local>
 <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
 <Pine.GSO.4.62.1103240628490.1156@umail> <AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
 <AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Mar 2011 16:48:21 -0700
Message-ID: <AANLkTi=x0ZZNfzCpKURXMCaiEncsFNQ2tg1zbARnJjx1@mail.gmail.com>
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

On Thu, Mar 24, 2011 at 1:05 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> If you think this has anything to do with Intel's ability to break your hardware
> on every merge then you've got your wires crossed.

No, it's about the fact that I expect to be pushed code that is
WRITTEN AND TESTED BEFORE THE MERGE WINDOW.

The merge window is not for writing new code. The code that gets
merged should have been written two weeks ago already. The only new
code that I want to see are actual regressions.

I have been talking about this for YEARS now. It's not a new issue. I
hate seeing patches sent to me while they are clearly still being
discussed and developed. There's something seriously wrong there when
that happens.

                           Linus
