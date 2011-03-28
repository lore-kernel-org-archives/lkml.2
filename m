Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1C1UQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:16:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:48497 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab1C1UQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:16:34 -0400
Date: Mon, 28 Mar 2011 22:16:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [GIT pull] irq cleanups for .39
In-Reply-To: <AANLkTintrwhwbyZGxX1Eecg9ZXo+NgRzTwyyMyzt1JGR@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103282210590.2774@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103282048370.2774@localhost6.localdomain6> <AANLkTintrwhwbyZGxX1Eecg9ZXo+NgRzTwyyMyzt1JGR@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-636335195-1301343393=:2774"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-636335195-1301343393=:2774
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Mon, 28 Mar 2011, Linus Torvalds wrote:

> On Mon, Mar 28, 2011 at 11:50 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Thomas Gleixner (1):
> >      vlynq: Convert irq functions
> 
> Can we please not use those irritating "LKML-Reference" lines in the commits?
> 
> The things are a pain. They don't work for google, they don't work for
> sh*t. They end up being effectively just random noise.
> 
> Either don't do them at all, or put a real pointer to a lkml archive
> that is actually *useful* - even if people might worry that it isn't
> going to be around forever. Eg something like
> 
>   http://lkml.org/lkml/2011/3/28/439
> 
> or similar.
> 
> Who has _ever_ found a use for those email ID's? I don't know who
> started doing this, but please stop it.

We started that for two reasons:

1) The commit bot replies to the original thread when we pick up a
   commit, which makes our live easier as we don't have to write
   "thanks, applied" mails manually.

2) msg ids are unique and can ge grepped for. also there are archives
   which allow searching for them.

   http://marc.info?i=alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6

   http://mid.gmane.org/alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6

3) msg ids are never going away, but the urls will ocassionally

Thanks,

	tglx
---1463795968-636335195-1301343393=:2774--
