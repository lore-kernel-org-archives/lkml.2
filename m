Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab1IOPPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:15:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60105 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab1IOPPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:15:20 -0400
Subject: Re: [BUG] infinite loop in find_get_pages()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Andrew Morton <akpm@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>, Hugh Dickins <hughd@google.com>,
        Alan Piszcz <ap@solarrain.com>
In-Reply-To: <13f5e10e68df485139384151da0ec4ed@agmk.net>
References: <1315941801.2565.19.camel@edumazet-laptop>
	 <20110913165344.1d800582.akpm@google.com>
	 <CAF1ivSbCb-eS=npyHO+iWuAXfKPjnCD+LZDWQQ9SbTxGg3nq7Q@mail.gmail.com>
	 <3669551.Uo4Qe4YO2W@pawels>
	 <alpine.DEB.2.02.1109150708540.23647@p34.internal.lan>
	 <1316088255.2893.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <13f5e10e68df485139384151da0ec4ed@agmk.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 17:15:26 +0200
Message-ID: <1316099726.2893.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 15 septembre 2011 à 17:00 +0200, Paweł Sikora a écrit :
> On Thu, 15 Sep 2011 14:04:15 +0200, Eric Dumazet wrote:
>  
> > Or just pull latest Linus tree. No need to repost those patches over 
> > and
> > over ;)
> >
> > from your local copy, do :
> >
> > git pull https://github.com/torvalds/linux.git
> 
>  i'm using the 3.0.x line and mentioned patch won't be helpful 
>  (https://lkml.org/lkml/2011/9/14/271).
> 

All mentioned patches are for 3.1 only.



