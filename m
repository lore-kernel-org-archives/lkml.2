Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1HZXQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:16:31 -0400
Received: from lucidpixels.com ([72.73.18.11]:52933 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1HZXQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:16:29 -0400
Date: Fri, 26 Aug 2011 19:16:28 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Steve French <smfrench@gmail.com>
cc: Jeff Layton <jlayton@samba.org>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
In-Reply-To: <CAH2r5mtrUq4aTHgqRyG-YZZoUztU4_k4rh+nXrN13CVckex8ZQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1108261914250.2203@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <3300.1313637592@jrobl> <alpine.DEB.2.02.1108180632000.10458@p34.internal.lan> <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan> <alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
 <20110818091140.385a9455@barsoom.rdu.redhat.com> <alpine.DEB.2.02.1108180914180.7903@p34.internal.lan> <20110818130408.71c55b96@barsoom.rdu.redhat.com> <alpine.DEB.2.02.1108181314310.7903@p34.internal.lan> <CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com>
 <alpine.DEB.2.02.1108181331180.7903@p34.internal.lan> <CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com> <alpine.DEB.2.02.1108181413030.7903@p34.internal.lan> <20110818145257.035a38e9@barsoom.rdu.redhat.com> <20110826175940.2830044d@tlielax.poochiereds.net>
 <alpine.DEB.2.02.1108261844170.2203@p34.internal.lan> <CAH2r5mtrUq4aTHgqRyG-YZZoUztU4_k4rh+nXrN13CVckex8ZQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Aug 2011, Steve French wrote:

> Fails with Jeff's new 20+ patch series?

Hi,

No, wanted to make sure it still mounted with 3.1-rc2+previous patches before 
doing anything, there have been quite a few patches applied recently on the
Windows host (updates) I'll need to check with the owner tomorrow; I want 
to ensure I can mount as before before applying Jeff's patches.

Justin.

