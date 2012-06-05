Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab2FETCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:02:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43957 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2FETCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:02:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAHGf_=qDy79cvHX3ym7RvkX7q9+2TDKhgtBHVj6+XHORczj94A@mail.gmail.com>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
 <CA+55aFzoVQ29C-AZYx=G62LErK+7HuTCpZhvovoyS0_KTGGZQg@mail.gmail.com>
 <alpine.DEB.2.00.1205301328550.31768@router.home> <20120530184638.GU27374@one.firstfloor.org>
 <alpine.DEB.2.00.1205301349230.31768@router.home> <20120530193234.GV27374@one.firstfloor.org>
 <alpine.DEB.2.00.1205301441350.31768@router.home> <CAHGf_=ooVunBpSdBRCnO1uOoswqxcSy7Xf8xVcgEUGA2fXdcTA@mail.gmail.com>
 <20120530201042.GY27374@one.firstfloor.org> <CAHGf_=r_ZMKNx+VriO6822otF=U_huj7uxoc5GM-2DEVryKxNQ@mail.gmail.com>
 <alpine.DEB.2.02.1205311744280.17976@asgard.lang.hm> <alpine.DEB.2.00.1206010850430.6302@router.home>
 <alpine.DEB.2.02.1206011230170.17976@asgard.lang.hm> <CAHGf_=qDy79cvHX3ym7RvkX7q9+2TDKhgtBHVj6+XHORczj94A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Jun 2012 12:02:25 -0700
X-Google-Sender-Auth: 9rKarOEe3KtuD9KteQ--kFPiFcU
Message-ID: <CA+55aFx6s34ss=5tjD4DT7X0WKRZfEsdk1ZiE-fkL3qao27z-A@mail.gmail.com>
Subject: Re: [PATCH 0/6] mempolicy memory corruption fixlet
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: david@lang.hm, Christoph Lameter <cl@linux.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        stable@vger.kernel.org, hughd@google.com, sivanich@sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm coming back to this email thread, because I didn't apply the
series due to all the ongoing discussion and hoping that somebody
would put changelog fixes and ack notices etc together.

I'd also really like to know that the people who saw the problem that
caused the current single patch (that this series reverts) would test
the whole series. Maybe that happened and I didn't notice it in the
threads, but I don't think so.

In fact, right now I'm assuming that the series will eventually come
to me through Andrew. Andrew, correct?

                       Linus
