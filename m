Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1BUWbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:31:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab1BUWbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:31:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: chris2553@googlemail.com
Subject: Re: [Bug #29322] System lockup with 2.6.38-rc4+
Date: Mon, 21 Feb 2011 23:30:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <xmAo3o4v0VF.A.eLH.HWtYNB@chimera> <5HY1m9_-mkI.A.tTH.QWtYNB@chimera> <201102212214.27880.chris2553@googlemail.com>
In-Reply-To: <201102212214.27880.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102212330.15474.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 21, 2011, Chris Clayton wrote:
> On Monday 21 February 2011, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.37.  Please verify if it still should be listed and let the
> > tracking team know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29322
> > Subject		: System lockup with 2.6.38-rc4+
> > Submitter	: Chris Clayton <chris2553@googlemail.com>
> > Date		: 2011-02-14 17:31 (8 days old)
> > Message-ID	: <201102141731.29331.chris2553@googlemail.com>
> > References	: http://marc.info/?l=linux-kernel&m=129770471724602&w=2
> 
> Yes, I think this should stay open. I haven't heard anything since I replied to 
> Ben Gamari on 14 February. having said that, I haven't experienced the lock up 
> again since I reported it. Perhaps it's been fixed without me knowing.

So, do I understand correctly that you're unable to reproduce the problem?

Rafael
