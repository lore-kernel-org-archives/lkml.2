Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0KJAzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:55:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121Ab0KJAzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:55:39 -0500
MIME-Version: 1.0
In-Reply-To: <20101109234852.GC5876@outflux.net>
References: <20101025235804.GA11760@outflux.net> <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
 <20101109205008.GU5876@outflux.net> <AANLkTint3yM44CouOvG_oA2K=_iC9AJuw-sJoB_HTUMT@mail.gmail.com>
 <20101109234852.GC5876@outflux.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Nov 2010 16:54:44 -0800
Message-ID: <AANLkTinCLMGWWD=8do9pv0vnFMX8njYyNgsMS+VeRfpQ@mail.gmail.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
To: Kees Cook <kees.cook@canonical.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 3:48 PM, Kees Cook <kees.cook@canonical.com> wrote:
>
>> I don't quite see where you got the particular collection of people from.
>
> I used scripts/get_maintainer.pl

Hmm. I get totally different results. You had

  linux-kernel@vger.kernel.org
  Al Viro <viro@zeniv.linux.org.uk>,
  Andrew Morton <akpm@linux-foundation.org>,
  Jiri Slaby <jslaby@suse.cz>,
  "David S. Miller" <davem@davemloft.net>

and I get

  Al Viro <viro@ZenIV.linux.org.uk>
  Andrew Morton <akpm@linux-foundation.org>
  Helge Deller <deller@gmx.de>
  David Howells <dhowells@redhat.com>
  Hugh Dickins <hughd@google.com>
  linux-kernel@vger.kernel.org

so there is something odd going on there.

                        Linus
