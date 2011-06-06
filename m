Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab1FFRUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:20:13 -0400
Received: from smtpout02.highway.telekom.at ([195.3.96.113]:29053 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753426Ab1FFRUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:20:11 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Regression: Borked display on second output with Intel G45 in 3.0-rc2
Date: Mon, 6 Jun 2011 19:20:06 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: Nick Bowler <nbowler@elliptictech.com>, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20110606171253.GA2925@elliptictech.com>
In-Reply-To: <20110606171253.GA2925@elliptictech.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061920.07144@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Bowler -- Monday 06 June 2011:
> After upgrading to 3.0-rc2, my second display is no longer working
> correctly on a desktop with an Intel G45 graphics chip.
[...]
> What I do know is that the problem was originally introduced by
> 49183b2818de ("drm/i915: Only enable the plane after setting the fb
> base (pre-ILK)").  It was subsequently fixed by 982b2035d9d7 ("Revert
> "drm/i915: Only enable the plane after setting the fb base (pre-ILK)"").
> The problem was reintroduced by 98b98d316349 ("Merge branch 'drm-core-next'
> of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6").

That's apparently the bug that I've submitted a patch for on 2011/5/31:
https://lkml.org/lkml/2011/5/31/393
I assume/hope it's still in someone's queue.

m.
