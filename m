Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0KIVtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:49:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57612 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab0KIVtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:49:45 -0500
Date: Tue, 9 Nov 2010 13:49:12 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
Message-ID: <20101109214912.GW5876@outflux.net>
References: <20101025235804.GA11760@outflux.net>
 <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
 <20101109205008.GU5876@outflux.net>
 <4CD9B463.6090504@kernel.org>
 <AANLkTin1FmyN7_-Jg9AWizfQ04+rVWhFRcpYZykBRJ0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin1FmyN7_-Jg9AWizfQ04+rVWhFRcpYZykBRJ0f@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Tue, Nov 09, 2010 at 11:34:50PM +0200, Pekka Enberg wrote:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3af54c9bd9e6f14f896aac1bb0e8405ae0bc7a44

Yes, it looks like Vasiliy Kulikov's version[0] from Oct 30th went in
instead of my second[1] or third[2] posting of the patches earlier in the
month.

-Kees

[0] http://lkml.org/lkml/2010/10/30/30
[1] http://lkml.org/lkml/2010/10/6/486
[2] http://lkml.org/lkml/2010/10/25/447

-- 
Kees Cook
Ubuntu Security Team
