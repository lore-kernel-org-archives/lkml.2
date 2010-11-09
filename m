Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0KIWyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:54:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448Ab0KIWyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:54:43 -0500
MIME-Version: 1.0
In-Reply-To: <20101109205008.GU5876@outflux.net>
References: <20101025235804.GA11760@outflux.net> <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
 <20101109205008.GU5876@outflux.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Nov 2010 14:46:30 -0800
Message-ID: <AANLkTint3yM44CouOvG_oA2K=_iC9AJuw-sJoB_HTUMT@mail.gmail.com>
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

On Tue, Nov 9, 2010 at 12:50 PM, Kees Cook <kees.cook@canonical.com> wrote:
>
> No one has committed it. I don't know why; I've sent it a few times now.

You seem to have sent it just to lkml. At least in this case the patch
itself was not sent to me (only the subsequent replies were), and the
choice of recipients was fairly odd apart from Andrew (who probably
_is_ the right person).

I don't quite see where you got the particular collection of people from.

                   Linus
