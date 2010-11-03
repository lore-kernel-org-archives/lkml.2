Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0KCRzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:55:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab0KCRzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <20101103174643.GA4985@localhost>
References: <201011010053.ADE86905.JMLFHVtSQOOFOF@I-love.SAKURA.ne.jp>
 <201011032011.BAB21899.OHVQtFLSFJMFOO@I-love.SAKURA.ne.jp> <20101103174643.GA4985@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Nov 2010 13:55:18 -0400
Message-ID: <AANLkTinC3=yO959Ci_tDN3ZCtnsXpXWDtWG6-9=g5ior@mail.gmail.com>
Subject: Re: [2.6.37-rc1] /proc/vmstat failure.
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "mrubin@google.com" <mrubin@google.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 1:46 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>
> It seems that m->private is of type (void *) while the original v is
> (unsigned long *). Can be fixed by the following patch.

Good catch.  Tetsuo, does that fix it for you?

And Wu - sign-off/changelog, please?

               Linus
