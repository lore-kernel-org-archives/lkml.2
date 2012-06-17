Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2FQS61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:58:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37915 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab2FQS60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:58:26 -0400
Date: Sun, 17 Jun 2012 19:58:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Message-ID: <20120617185822.GD10241@sirena.org.uk>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
 <20120615233413.GB8894@kroah.com>
 <alpine.LFD.2.02.1206161103320.3086@ionos>
 <20120616072906.7469ec24@tpl.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616072906.7469ec24@tpl.lwn.net>
X-Cookie: "But I don't like Spam!!!!"
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 07:29:06AM -0600, Jonathan Corbet wrote:

> Any thoughts on how to measure "consolidation effects"?  I toss out
> numbers on code removal sometimes, but that turns out to not be a whole
> lot more useful than anything else on its own.

It'd probably help if we could split out the framework and driver code,
but at the end of the day it's all just stats and therefore has to be
taken with a pinch (or large helping) of salt.
