Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab1E3MKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:10:17 -0400
Received: from smtpout01.highway.telekom.at ([195.3.96.112]:10401 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751444Ab1E3MKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:10:15 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [3.0-rc1 regression] (was: Re: [2.6.39 regression] i915/kms: garbled screen because of 49183b281)
Date: Mon, 30 May 2011 14:10:10 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
References: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com> <201105121849.09225@rk-nord.at>
In-Reply-To: <201105121849.09225@rk-nord.at>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105301410.11270@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Melchior FRANZ -- Thursday 12 May 2011:
> > Chris Wilson (4):
> >       drm/i915: Only enable the plane after setting the fb base (pre-ILK)
> 
> This patch introduces a bug on my infamous "Acer Travelmate
> 5735Z-452G32Mnss": when KMS takes over, the frame buffer contents
> get completely garbled up on screen, with colored stripes and
> unreadable text (photo on request). Only when X11 is started, the
> screen gets restored again. Closing and re-opening the lid partly
> cures the mess, too: it makes the font readable, though horizontally
> stretched.
> 
> Reverting 49183b2818de6899383bb82bc032f9344d6791ff fixes the
> bug.

This got fixed after my bug report, but now it's back with exactly
the same description. Bisection result to come ...

m.
