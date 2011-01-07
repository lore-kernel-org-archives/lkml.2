Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab1AGIac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:30:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46720 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1AGIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P6PBhy1buvk/pP3uaQAPeMQVyVv7c/NeFQMOktbo+h9YEkRYCe1PYuDCFZDmydlwqZ
         MDUKjxGhduF7V+p0RCT67syT7fjioX99WYwwMzvptYr0+0rxrxW9QnHArhCyrPfnthcj
         mX1SP7inOEc1i+0lo5Ejxqxj0UF2tLhXJZ6MQ=
Subject: Re: [058/152] tcp: protect sysctl_tcp_cookie_size reads
From: Eric Dumazet <eric.dumazet@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4D2691D4.3060304@gmail.com>
References: <20110106002302.141581701@clark.site>
	 <4D2691D4.3060304@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 09:30:25 +0100
Message-ID: <1294389025.2704.95.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 06 janvier 2011 à 23:08 -0500, William Allen Simpson a écrit :
> Thank you for bringing this to my attention.  There's been quite a few
> changes in the 18 months since this function was originally written.
> 
> The overall purpose of the patch seems OK, although most of the patch
> has nothing to do with the purported fix.
> 
> That is, somebody preferred to alter conditions and remove braces.  Seems
> harder to read to me!  I'm surprised that this passed checkpatch.pl?
> 

Hi William, here is somebody talking to you.

This part of the code was exactly what you wrote, with no change.

http://patchwork.ozlabs.org/patch/40126/

Are you telling us somebody else added bug to your code ?
This is not the case, obviously.

After bug fix and cleanup code looks good, and even checkpatch.pl is
fine with it. No need for useless brackets around "return XXX;"
If I remember well, I did the cleanup so that my patch could not trigger
checkpatch.pl errors/warnings. Not that I am a particular checkpatch
fan, but I know some people are.

By the way, you were CCed when I sent one month ago the mail to
David/netdev. And no reaction from you at that time.



