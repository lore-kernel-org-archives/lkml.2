Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975Ab1IOPAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:00:33 -0400
Received: from mail.agmk.net ([91.192.224.71]:44000 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab1IOPAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:00:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Sep 2011 17:00:27 +0200
From: =?UTF-8?Q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Andrew Morton <akpm@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>, Hugh Dickins <hughd@google.com>,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: [BUG] infinite loop in =?UTF-8?Q?find=5Fget=5Fpages=28=29?=
In-Reply-To: <1316088255.2893.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1315941801.2565.19.camel@edumazet-laptop>
 <20110913165344.1d800582.akpm@google.com>
 <CAF1ivSbCb-eS=npyHO+iWuAXfKPjnCD+LZDWQQ9SbTxGg3nq7Q@mail.gmail.com>
 <3669551.Uo4Qe4YO2W@pawels>
 <alpine.DEB.2.02.1109150708540.23647@p34.internal.lan>
 <1316088255.2893.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <13f5e10e68df485139384151da0ec4ed@agmk.net>
User-Agent: RoundCube Webmail/0.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Thu, 15 Sep 2011 14:04:15 +0200, Eric Dumazet wrote:
 
> Or just pull latest Linus tree. No need to repost those patches over 
> and
> over ;)
>
> from your local copy, do :
>
> git pull https://github.com/torvalds/linux.git

 i'm using the 3.0.x line and mentioned patch won't be helpful 
 (https://lkml.org/lkml/2011/9/14/271).

