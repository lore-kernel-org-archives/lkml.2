Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab1EVGL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 02:11:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:36372 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab1EVGLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 02:11:51 -0400
Date: Sat, 21 May 2011 23:11:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dan Rosenberg <drosenberg@vsecurity.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
In-Reply-To: <BANLkTinCnqrzMyoSzS04fCAqks1bd9Y8=g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105212308510.8167@asgard.lang.hm>
References: <1305292059.1949.0.camel@dan> <1305293345.1949.22.camel@dan> <20110516153527.GC21107@elte.hu> <1305852966.3005.19.camel@dan> <20110520120750.GJ14745@elte.hu> <1305896093.3005.24.camel@dan> <20110520131108.GA17699@elte.hu> <1305913261.20623.12.camel@dan>
 <BANLkTinCnqrzMyoSzS04fCAqks1bd9Y8=g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, Linus Torvalds wrote:

> Sure, it will likely leave some hints around (oopses etc), but still..
>

as an admin running a large site, I'd love to have evidence around that 
strange things were happening, especially prior to the exploit running.

no, I probably can't take manual action fast enough to prevent the initial 
exploit, but I can alarm on the failed attacks and potentially react fast 
enough to prevent the attacker from going further into my network.

David Lang
