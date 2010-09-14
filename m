Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0INU5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:57:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294Ab0INU5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:57:18 -0400
MIME-Version: 1.0
In-Reply-To: <4C8FD6E1.3040507@kernel.org>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org>
 <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com>
 <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com> <4C8FD6E1.3040507@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Sep 2010 13:56:29 -0700
Message-ID: <AANLkTimcy2Y3CZc_00axpRirHoidk49KS1hq-_p8a9jx@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
To: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 1:11 PM, Pekka Enberg <penberg@kernel.org> wrote:
>
> Are you happy with the patch? The output is indeed tad bit unreadable. Maybe
> we should just limit the number of printed out names to two or three?

I think the patch looked fine. And limiting the printout to perhaps
just two names (+ "..." if you have more) would work for me. At least
at that point the output of /proc/slabinfo is no longer misleading and
_incorrect_, it's just "incomplete" (and at that point the whole "you
can get the full information from /sys" is a valid argument)

                                   Linus
