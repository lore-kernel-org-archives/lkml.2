Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1BUBLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 20:11:23 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:33522 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1BUBLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 20:11:22 -0500
Message-ID: <af572f9c6c75d54f1f81e51f508358dd.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110220132115.GC3514@viiv.ffwll.ch>
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
    <20110219182511.GA3977@viiv.ffwll.ch>
    <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
    <20110220105514.GB3514@viiv.ffwll.ch>
    <b51c68e52b0495f1c354f200bc50c7ec.squirrel@webmail.greenhost.nl>
    <20110220132115.GC3514@viiv.ffwll.ch>
Date: Mon, 21 Feb 2011 02:11:19 +0100 (CET)
Subject: Re: [BUG] drm/i915 Screen corruption introduced by 
     a00b10c360b35d6431a94cb
From: "Indan Zupancic" <indan@nul.nu>
To: "Daniel Vetter" <daniel@ffwll.ch>
Cc: "Indan Zupancic" <indan@nul.nu>, "Chris Wilson" <chris@chris-wilson.co.uk>,
        "LKML" <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: b011d5308189b8f364b008c39e0eea9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, February 20, 2011 14:21, Daniel Vetter wrote:
> Well, don't start jumping around, yet. These patches are just to rule
> out some theories.

I know, that's why I said I don't mind testing other patches.

> Now: Is it fixed with just the 2nd patch alone or do you
> need both patches? This is very important, so please test extensively
> whether there are really no corruptions with just the 2nd patch.

I only applied the 2nd version of the 2nd patch, no other patches.
The horizontal garbage stripes are gone for sure. It's a lot easier
to prove that something doesn't work than to prove it does, but I'll
keep running it for a while and see if I can spot any other badness.
If it's hard to trigger it's also very hard to find out what causes it.
Without your 2nd patch I always get the garbage on certain webpages,
so I'm quite confident that the original source is located for this
particular problem.

Greetings,

Indan


