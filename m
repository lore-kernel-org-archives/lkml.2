Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab2FPNup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 09:50:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45475 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab2FPNuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:50:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ksummit-2012-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the question!
Date: Sat, 16 Jun 2012 15:56:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.02.1206152313310.3086@ionos> <alpine.LFD.2.02.1206161103320.3086@ionos> <20120616072906.7469ec24@tpl.lwn.net>
In-Reply-To: <20120616072906.7469ec24@tpl.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206161556.03410.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 16, 2012, Jonathan Corbet wrote:
> On Sat, 16 Jun 2012 12:50:05 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > A good start would be if you could convert your kernel statistics into
> > accounting the consolidation effects of contributions instead of
> > fostering the idiocy that corporates have started to measure themself
> > and the performance of their employees (I'm not kidding, it's the sad
> > reality) with line and commit count statistics.
> 
> I would dearly love to come up with a way to measure "real work" in
> some fashion; I've just not, yet, figured out how to do that.  I do
> fear that the simple numbers we're able to generate end up creating the
> wrong kinds of incentives.

I have exactly the same feeling about that.

> Any thoughts on how to measure "consolidation effects"?  I toss out
> numbers on code removal sometimes, but that turns out to not be a whole
> lot more useful than anything else on its own.

Well, that is very difficult to measure.  I'd look for cases in which certain
function calls and data types become more widespread.
