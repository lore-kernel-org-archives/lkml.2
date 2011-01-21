Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab1AUFhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 00:37:01 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47272 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1AUFg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 00:36:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=D0eQT0TIvDwMvAYAtE7FdNFDGfs4rZ2O0X5rKPA0AkSQOtouCJlO5FwIHtKoe5xzpg
         fwajwsOq7VaXQl2z5//WRV42wYmcM5kSg55pZh+DrfpqZnO+mOqi2PUrx6lASY1WuiyC
         gssqHZioeGOfh6CSEDvaFOrvAof9xdejOwgRo=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 21 Jan 2011 06:36:54 +0100
Message-ID: <AANLkTimogiJMKkcgfOCJHxpyZHcB36+xzRFgkqWPOiv_@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 2/5] i915: Add native backlight control
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
Cc: DRI <dri-devel@lists.freedesktop.org>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( Original posting from [1] )

I have the backlight-type patchset for months in my patch-series (and
maintained them if necessary against daily linux-next).
Also the last series from 14-Jan-2011 (see 1-5 patch from [2] and the
following ones at dri-devel ML).

If you couldn't find the updated v2 radeon-backlight-type patch, here
the extract from my patch-series:
...
# Patch from <https://patchwork.kernel.org/patch/491351/>
+ backlight-type/v2-drm-radeon-kms-Expose-backlight-class-device-for-legacy-LVDS-encoder.patch
...

I can only speak for the radeon(-KMS) part with
CONFIG_BACKLIGHT_CLASS_DEVICE=y set and against linux-next: It worked,
it works.

I am a bit angry that someone of the "big 5" gets immediately an
answer where mine is ignored [3].
So dear Mr. AKPM, if you can standstill for a few moments to answer
only one of my questions, through which kernel-tree will this patchset
walk trough?
Thanks in advance.

- Sedat -

[1] http://lists.freedesktop.org/archives/dri-devel/2011-January/007378.html
[2] http://lists.freedesktop.org/archives/dri-devel/2011-January/007168.html
[3] http://lists.freedesktop.org/archives/dri-devel/2011-January/007193.html
