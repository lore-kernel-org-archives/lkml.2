Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935654Ab1ETLv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:51:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42282 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935491Ab1ETLv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:51:28 -0400
Date: Fri, 20 May 2011 13:51:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/4] watchdog: fix rounding issues in get_sample_period()
Message-ID: <20110520115118.GF14745@elte.hu>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <20110518135302.GM29881@redhat.com>
 <20110519162631.GJ11023@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519162631.GJ11023@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@chromium.org> wrote:

> Ingo, since Don is out, would you mind acking the patches (assuming you're 
> happy). It simplifies pushing these patches into our local ChromiumOS tree if 
> I have an upstream ack.

I suspect it would simplify things even more for you if they were all upstream, 
right?

To get that process underway please send an updated series with (delta) patches 
against -tip.

Thanks,

	Ingo
