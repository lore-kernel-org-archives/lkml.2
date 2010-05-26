Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab0EZKti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:49:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35977 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0EZKth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:49:37 -0400
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
In-Reply-To: <AANLkTikRMBkoFxgaKsxMJ2lOMomTXpiHJDk3rVt0EtwM@mail.gmail.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <87wrusvrqe.fsf@deeprootsystems.com> <201005250138.16293.rjw@sisk.pl>
	 <1274863655.5882.4875.camel@twins>
	 <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	 <1274867106.5882.5090.camel@twins>
	 <AANLkTiksR3YozbBH0Iv5kNsQkEGKCH1APCvn_s6LkjV9@mail.gmail.com>
	 <1274868593.5882.5185.camel@twins>
	 <AANLkTinuxCbeBmxIR7b_1OtrqQYJCamiDZJbnNTih1Fb@mail.gmail.com>
	 <1274869966.5882.5262.camel@twins>
	 <AANLkTikRMBkoFxgaKsxMJ2lOMomTXpiHJDk3rVt0EtwM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 12:49:30 +0200
Message-ID: <1274870970.5882.5311.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 03:40 -0700, Arve Hjønnevåg wrote:
> 2010/5/26 Peter Zijlstra <peterz@infradead.org>:
> > On Wed, 2010-05-26 at 03:25 -0700, Arve Hjønnevåg wrote:
> >
> >> and on systems where the
> >> same power state can be used from idle and suspend, we use suspend so
> >> we can stay in the low power state for minutes to hours instead of
> >> milliseconds to seconds.
> >
> > So don't you think working on making it possible for systems to be idle
> > _that_ long would improve things for everybody? as opposed to this
> > auto-suspend which only improves matters for those that (can) use it?
> 
> I'm not preventing anyone from working on improving this. Currently
> both the kernel and our user-space code polls way too much. I don't
> think it is reasonable to demand that no one should run any user-space
> code with periodic timers when we have not even fixed the kernel to
> not do this.

All I'm saying is that merging a stop-gap measure will decrease the
urgency and thus the time spend fixing the actual issues while adding
the burden of maintaining this stop-gap measure.
