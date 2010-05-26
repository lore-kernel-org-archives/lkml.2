Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0EZM2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:28:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41756 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884Ab0EZM2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:28:15 -0400
Date: Wed, 26 May 2010 13:35:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, felipe.balbi@nokia.com,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526133510.6e9de670@lxorguk.ukuu.org.uk>
In-Reply-To: <1274872357.27810.16.camel@twins>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<AANLkTiksR3YozbBH0Iv5kNsQkEGKCH1APCvn_s6LkjV9@mail.gmail.com>
	<1274868593.5882.5185.camel@twins>
	<AANLkTinuxCbeBmxIR7b_1OtrqQYJCamiDZJbnNTih1Fb@mail.gmail.com>
	<1274869966.5882.5262.camel@twins>
	<AANLkTikRMBkoFxgaKsxMJ2lOMomTXpiHJDk3rVt0EtwM@mail.gmail.com>
	<1274870970.5882.5311.camel@twins>
	<AANLkTinlxsokwralwRAL9_YRQ7-SZUSvrGHTlRISA9bC@mail.gmail.com>
	<1274872357.27810.16.camel@twins>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think x86 is relevant anyway, it doesn't suspend/resume anywhere
> near fast enough for this to be usable.

Yet...

> My laptop still takes several seconds to suspend (Lenovo T500), and
> resume (aside from some userspace bustage) takes the same amount of
> time. That is quick enough for manual suspend, but I'd hate it to try
> and auto-suspend.

This is an area where machines are improving and where the ability to
do stuff like autosuspend, the technology like the OLPC screen and so on
create an incentive for the BIOS and platform people to improve their
bits of it.

> So yes, I do think merging this will delay the effort in fixing
> userspace, simply because all the mobile/embedded folks don't care about
> it anymore.

The mobile space probably doesn't care too much about many of the large
bloated desktop apps anyway and traditional embedded generally has a very
small fixed application set where the optimise both halves of the system
together.

Alan
