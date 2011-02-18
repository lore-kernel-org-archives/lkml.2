Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1BREjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:39:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218Ab1BREi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:38:59 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
References: <20110216185234.GA11636@tiehlicka.suse.cz> <20110216193700.GA6377@elte.hu>
 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
 <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
 <20110217090910.GA3781@tiehlicka.suse.cz> <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
 <20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
 <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
 <m1sjvm822m.fsf@fess.ebiederm.org> <AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 20:38:09 -0800
Message-ID: <AANLkTi=kEEip7UjtLqvo0Hpz8uwjVdx334hYnPsoNXis@mail.gmail.com>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Octavian Purdila <opurdila@ixiacom.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 8:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The patch from Eric Dumazet (which adds a few more cases to my patch
> and hopefully catches them all) almost certainly fixes this rather
> nasty memory corruption.

Oh, but you weren't cc'd on that part of the thread, since the thread
got started from Michal Hocko's similar trouble. So you may have never
even noticed that patch, or my "improved LIST_DEBUG" patch in the same
thread)

You can find Eric Dumazet's patch on lkml (see the background at

  http://lkml.org/lkml/2011/2/17/267

and you'll see Dumazet's reply and my improved list debugging too).

Eric Dumazet: have you made any other changes to that patch? Or should
Eric (too many Eric's in this thread ;) just test the patch you
posted?

                          Linus
