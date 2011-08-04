Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1HDB3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:29:41 -0400
Received: from tundra.namei.org ([65.99.196.166]:57104 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab1HDB3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:29:34 -0400
Date: Thu, 4 Aug 2011 11:28:35 +1000 (EST)
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
Message-ID: <alpine.LRH.2.00.1108041128010.25037@tundra.namei.org>
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

Seems reasonable to me.

-- 
James Morris
<jmorris@namei.org>
