Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab3ADNa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:30:27 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:59314 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3ADNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:30:25 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 4 Jan 2013 14:30:24 +0100
Message-ID: <CA+icZUXjbJtg1Qasf=f1SQeLASgsCVvUr4bSG6HGHxpXpeFg0g@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Treat crtc->mode.clock == 0 as disabled
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Shuah Khan <shuahkhan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

I have tested the patch from Linus [2] and your patch from [1] on top
of Linux v3.8-rc2.

Feel free to add a "Tested-by".

Regards,
- Sedat -

[1] https://patchwork.kernel.org/patch/1932791/
[2] http://marc.info/?l=linux-kernel&m=135725516602511&w=2
