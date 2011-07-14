Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1GNHhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 03:37:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36055 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab1GNHhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 03:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <yunhb6rec97.fsf@aiko.keithp.com>
References: <20110621142133.GA3652@fujiko>
	<yunhb7jxkz2.fsf@aiko.keithp.com>
	<20110621155205.GA2488@fujiko>
	<yunboxrxiz2.fsf@aiko.keithp.com>
	<20110621164209.GA2155@fujiko>
	<yun8vsvxdr4.fsf@aiko.keithp.com>
	<20110621184757.GA2185@fujiko>
	<yunzklb9fg1.fsf@aiko.keithp.com>
	<20110705230101.GD2852@fujiko>
	<CAOJsxLFVSEDEaYH8Dw4jWGo9=wkC8QQWOs4xRR6qcgVM2xCRoA@mail.gmail.com>
	<yunhb6rec97.fsf@aiko.keithp.com>
Date: Thu, 14 Jul 2011 10:37:15 +0300
X-Google-Sender-Auth: UVR_DQSJoC1SMzFagsRknpMijQA
Message-ID: <CAOJsxLGKtjCpY=X1UrHVY79qLjVCgCT3XC795yh_uEn-0_4D0w@mail.gmail.com>
Subject: Re: Reverting rc6 by default
From: Pekka Enberg <penberg@kernel.org>
To: Keith Packard <keithp@keithp.com>
Cc: Francesco Allertsen <fallertsen@gmail.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 10:33:06 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>> AFAICT, this problem is still there in 3.0-rc7. Keith, isn't it time
>> to revert commit a51f7a6 ("drm/i915: enable rc6 by default") before
>> 3.0 is out?

On Tue, Jul 12, 2011 at 6:42 PM, Keith Packard <keithp@keithp.com> wrote:
> Yes. I'll put together a few tiny patches including this.

This if fixed in mainline as of commit
a94919eaddaa3fede1df8563ce4d761a75374645 ("Revert "drm/i915: enable
rc6 by default"). Keith, it would have been nice to include a
'Reported-by' and/or a link to this discussion in the changelog for
future reference.

                        Pekka
