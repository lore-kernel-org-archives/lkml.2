Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1H0Op6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:45:58 -0400
Received: from mail-gy0-f194.google.com ([209.85.160.194]:47227 "EHLO
	mail-gy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1H0Opy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:45:54 -0400
Date: Sat, 27 Aug 2011 10:31:49 -0400
From: Jeff Layton <jlayton@samba.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Steve French <smfrench@gmail.com>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also
 crashes with linux-3.1-rc2
Message-ID: <20110827103149.2d186dbb@tlielax.poochiereds.net>
In-Reply-To: <alpine.DEB.2.02.1108261914250.2203@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108180632000.10458@p34.internal.lan>
	<alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
	<alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
	<20110818091140.385a9455@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108180914180.7903@p34.internal.lan>
	<20110818130408.71c55b96@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108181314310.7903@p34.internal.lan>
	<CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com>
	<alpine.DEB.2.02.1108181331180.7903@p34.internal.lan>
	<CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com>
	<alpine.DEB.2.02.1108181413030.7903@p34.internal.lan>
	<20110818145257.035a38e9@barsoom.rdu.redhat.com>
	<20110826175940.2830044d@tlielax.poochiereds.net>
	<alpine.DEB.2.02.1108261844170.2203@p34.internal.lan>
	<CAH2r5mtrUq4aTHgqRyG-YZZoUztU4_k4rh+nXrN13CVckex8ZQ@mail.gmail.com>
	<alpine.DEB.2.02.1108261914250.2203@p34.internal.lan>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 19:16:28 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> 
> 
> On Fri, 26 Aug 2011, Steve French wrote:
> 
> > Fails with Jeff's new 20+ patch series?
> 
> Hi,
> 
> No, wanted to make sure it still mounted with 3.1-rc2+previous patches before 
> doing anything, there have been quite a few patches applied recently on the
> Windows host (updates) I'll need to check with the owner tomorrow; I want 
> to ensure I can mount as before before applying Jeff's patches.
> 
> Justin.
> 

Doubtful that it's related to your -ENOMEM problem, but I have found a
couple of problems with the async read patchset. You may want to wait on
testing it just yet. I've fixed a couple of the problems, but there's
one I'm still hunting down.

Steve, you may want to wait on merging any of it until I understand
what the problem actually is. I'll re-post the set once I get it
straightened out.

Thanks,
-- 
Jeff Layton <jlayton@samba.org>
