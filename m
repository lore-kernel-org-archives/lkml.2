Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab0HVQoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 12:44:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037Ab0HVQoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 12:44:03 -0400
MIME-Version: 1.0
In-Reply-To: <1282470917.11348.891.camel@localhost.localdomain>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
 <1282391770.29609.1223.camel@localhost.localdomain> <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
 <1282460275.11348.865.camel@localhost.localdomain> <1282462386.11348.871.camel@localhost.localdomain>
 <1282470917.11348.891.camel@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 Aug 2010 09:43:29 -0700
Message-ID: <AANLkTikku=2XV84Y9PHz-Nf=dY=WjP6bG4LqZU_zrLOC@mail.gmail.com>
Subject: Re: [RFC] mlock/stack guard interaction fixup
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 2:55 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
>
> In the meantime I notice you've committed the patches. Can we get them
> queued up for stable backports at some point? I appreciate you might
> want them to bake for a bit longer in 2.6.36-rc first.

Yeah, I think I want them in -rc2 (which I'll do today) and get some
more testing first. The patches are simple, but let's see if I missed
anything else for a couple of days.

                        Linus
