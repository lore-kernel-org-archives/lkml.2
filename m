Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3AFU40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 15:56:26 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44698 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3AFU4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 15:56:24 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1357299595-16037-1-git-send-email-chris@chris-wilson.co.uk>
References: <CAB9v_DE0qMdQ2poxv++FGd2zo+Tw5_m6kgTOoBZSCUOGZf+fNA@mail.gmail.com>
	<1357299595-16037-1-git-send-email-chris@chris-wilson.co.uk>
Date: Sun, 6 Jan 2013 21:56:22 +0100
Message-ID: <CAKMK7uH2L=tPUszeO7XMHJjXiJ5ZcG+wVi5u5c2UeQa8-xM=YQ@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Treat crtc->mode.clock == 0 as disabled
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 12:39 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> Prevent a divide-by-zero by consistently treating an 'active' CRTC
> without a mode set as actually disabled.

Can you please resend with sob/tested-by/lkml-references and
regression sha1 citation and maybe a small comment in the code that
this additional protection is required due to half-done fastboot
support? I'd like to merge it asap and forward the patch to
Dave/Linus.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
