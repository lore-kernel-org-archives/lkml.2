Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1HENqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:46:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:53240 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1HENqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:46:08 -0400
Date: Fri, 5 Aug 2011 23:45:10 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jonathan Nieder <jrnieder@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Gergely Nagy <algernon@balabit.hu>, david@lang.hm,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marc Koschewski <marc@osknowledge.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH/RFC] cap_syslog: make CAP_SYS_ADMIN deprecation notice
 less alarming
In-Reply-To: <20110803164837.GA2669@elie>
Message-ID: <alpine.LRH.2.00.1108052344490.6696@tundra.namei.org>
References: <20110210144057.GA7193@mail.hallyn.com> <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com> <20110803164837.GA2669@elie>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011, Jonathan Nieder wrote:

> Convert the WARN_ONCE to a printk_once to avoid this while continuing
> to give userspace developers a hint that this is an unwanted
> backward-compatibility feature and won't be around forever.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-queue

-- 
James Morris
<jmorris@namei.org>
