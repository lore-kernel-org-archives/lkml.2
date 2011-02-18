Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab1BRQj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:39:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932076Ab1BRQjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:39:55 -0500
MIME-Version: 1.0
In-Reply-To: <20110218162623.GD4862@tiehlicka.suse.cz>
References: <20110216185234.GA11636@tiehlicka.suse.cz> <20110216193700.GA6377@elte.hu>
 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
 <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
 <20110217090910.GA3781@tiehlicka.suse.cz> <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
 <20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
 <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
 <20110218122938.GB26779@tiehlicka.suse.cz> <20110218162623.GD4862@tiehlicka.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Feb 2011 08:39:02 -0800
Message-ID: <AANLkTimO=M5xG_mnDBSxPKwSOTrp3JhHVBa8=wHsiVHY@mail.gmail.com>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
To: Michal Hocko <mhocko@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 8:26 AM, Michal Hocko <mhocko@suse.cz> wrote:
>> Now, I will try with the 2 patches patches in this thread. I will also
>> turn on DEBUG_LIST and DEBUG_PAGEALLOC.
>
> I am not able to reproduce with those 2 patches applied.

Thanks for verifying. Davem/EricD - you can add Michal's tested-by to
the patches too.

And I think we can consider this whole thing solved. It hopefully also
explains all the other random crashes that EricB saw - just random
memory corruption in other datastructures.

EricB - do all your stress-testers run ok now?

                    Linus
