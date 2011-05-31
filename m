Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1EaJX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:23:29 -0400
Received: from 1wt.eu ([62.212.114.60]:36527 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab1EaJX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:23:28 -0400
Date: Tue, 31 May 2011 11:23:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc1
Message-ID: <20110531092321.GA5511@1wt.eu>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 06:30:32PM -0700, Linus Torvalds wrote:
> Yay! Let the bikeshed painting discussions about version numbering
> begin (or at least re-start).
> 
> I decided to just bite the bullet, and call the next version 3.0. It
> will get released close enough to the 20-year mark, which is excuse
> enough for me, although honestly, the real reason is just that I can
> no longe rcomfortably count as high as 40.
> 
> The whole renumbering was discussed at last years Kernel Summit, and
> there was a plan to take it up this year too. But let's face it -
> what's the point of being in charge if you can't pick the bike shed
> color without holding a referendum on it? So I'm just going all
> alpha-male, and just renumbering it. You'll like it.
> 
> Now, my alpha-maleness sadly does not actually extend to all the
> scripts and Makefile rules, so the kernel is fighting back, and is
> calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle it
> into submission, and get scripts etc cleaned up, and the final release
> should be just "3.0". The -stable team can use the third number for
> their versioning.

Linus, two words : THANK YOU !

The 4-integer numbering was a real nightmare with kernel versions looking
like IP addresses. Now it will get back to something more common and much
more maintainable.

Thanks again for this huge step forwards !

Willy

