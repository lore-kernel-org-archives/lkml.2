Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1ECOOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:14:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46708 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1ECOOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:14:39 -0400
Date: Tue, 3 May 2011 15:14:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC patch 29/32] trace event asoc remove semicolons
Message-ID: <20110503141436.GB2893@sirena.org.uk>
References: <20110502211123.163877033@efficios.com> <20110502213216.050459585@efficios.com> <20110503132138.GL1762@opensource.wolfsonmicro.com> <20110503140647.GA29665@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503140647.GA29665@Krystal>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 10:06:47AM -0400, Mathieu Desnoyers wrote:
> * Mark Brown (broonie@opensource.wolfsonmicro.com) wrote:

> > This is an unrelated change and should be split out.  Frankly I'm not
> > that this is an improvement anyway, the struct declarations aren't going
> > to do any harm...

> Yes, this change is related, because these declarations will cause harm.
> The structure declaration cannot be put within an array declaration,
> because then they won't be simply "ignored": they will try to declare
> structures within an array, which is not valid. This is why I did this
> change in the same patch.

This might make a bit more sense if we'd seen the earlier or possibly
later patches...  According to the patch description all you're doing
here is removing the semicolons.
