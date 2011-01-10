Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1AJNoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:44:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:43677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab1AJNoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:44:22 -0500
Subject: Re: TSC as clocksource
From: Peter Zijlstra <peterz@infradead.org>
To: Rob <roblinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Brown, Len" <lenb@kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTikBu6vggpTUQy_MeTG_PJ9WWoHVyDL0OLPa6v=_@mail.gmail.com>
References: <AANLkTikBu6vggpTUQy_MeTG_PJ9WWoHVyDL0OLPa6v=_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 Jan 2011 14:44:52 +0100
Message-ID: <1294667092.11896.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 09:54 +1100, Rob wrote:
> Want to use TSC as clocksource
> have a Intel Core2 Duo with constant_tsc flag
> TSC should be stable at C1 + C2, it is debatable whether C3 is stable
> 
> Using processor.max_cstate=2 to use only C1 + C2 changes nothing, still get
> Monitor-Mwait will be used to enter C-3 state
> there should be checks before this is forced
> 
> Please CC answers, comments to my email.

Len, Thomas?
