Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1HIQ4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:56:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37514 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1HIQ4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:56:31 -0400
MIME-Version: 1.0
In-Reply-To: <20110809163206.GA3410@tugrik.mns.mnsspb.ru>
References: <013811$4lfs6@fmsmga002.fm.intel.com> <201108091809.58425.anarsoul@gmail.com>
 <20110809153446.GA22077@tugrik.mns.mnsspb.ru> <201108091903.00071.anarsoul@gmail.com>
 <20110809163206.GA3410@tugrik.mns.mnsspb.ru>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Tue, 9 Aug 2011 09:56:01 -0700
X-Google-Sender-Auth: MM7HXC-8pndrzo7PzCOukSsFmiE
Message-ID: <CADU53JVXiX2v+5N-VP8mz6vnxF60BYYXKV_PZQdd_U+qM5Gd6A@mail.gmail.com>
Subject: Re: [Intel-gfx] Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>, intel-gfx@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Herbert Xu <herbert@gondor.hengli.com.au>, Luke-Jr <luke@dashjr.org>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 9:32 AM, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> Quite frankly, I don't understand intel-gfx developers attitude: why is
> it me, just random user who is nitpicking here? Why there is no
> interest/will to analyze now obviously buggy/duplicate code and fix it?

Because they don't have an infinite amount of manpower. Actual bugs
hitting actual users take precedence over 'cleanups' which always have
a chance of causing regressions, as you're well aware. Code churn for
the sake of abstract prettiness is discouraged, as it has a potential
cost for little potential gain.

If you like, submit a patch. You may now be more up-to-date on those
particular code paths than most of the intel-gfx developers.
