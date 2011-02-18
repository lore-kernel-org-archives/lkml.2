Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab1BRE6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:58:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab1BRE6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:58:33 -0500
MIME-Version: 1.0
In-Reply-To: <20110217.204036.226788819.davem@davemloft.net>
References: <m1sjvm822m.fsf@fess.ebiederm.org> <AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
 <AANLkTi=kEEip7UjtLqvo0Hpz8uwjVdx334hYnPsoNXis@mail.gmail.com> <20110217.204036.226788819.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 20:57:39 -0800
Message-ID: <AANLkTin2XX-HHFqnAajUYPU23WeuOZk7vvGczmijUEy=@mail.gmail.com>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, mingo@elte.hu, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        opurdila@ixiacom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 8:40 PM, David Miller <davem@davemloft.net> wrote:
>
> I looked at Eric's (and your) patch before I wrote my reply :-)

It was Eric Biederman that was missing from some of the discussion.
Too many Eric's, and two separate threads for the same bug that I'm
involved in.

                       Linus
