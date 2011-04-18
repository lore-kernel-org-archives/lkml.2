Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1DRVWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:22:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab1DRVWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:22:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Subject: Re: [Bug #32902] 2.6.39-rc1 doesn't boot on thinkpad t61p x86_64
Date: Mon, 18 Apr 2011 23:22:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.-JC.2GuqNB@chimera> <87ipub7evl.fsf@sycorax.lbl.gov>
In-Reply-To: <87ipub7evl.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201104182322.56995.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 18, 2011, Alex Romosan wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.38. Please verify if it still should be listed and let the
> > tracking team
> > know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32902
> > Subject		: 2.6.39-rc1 doesn't boot on thinkpad t61p x86_64
> > Submitter	: Alex Romosan <romosan@sycorax.lbl.gov>
> > Date		: 2011-04-03 19:41 (15 days old)
> > Message-ID	: <87k4fbnmw8.fsf@sycorax.lbl.gov>
> > References	: http://marc.info/?l=linux-kernel&m=130186054431678&w=2
> >
> 
> my laptop works again with 2.6.39-rc3 (except the boot process hangs at
> waiting for /dev to be populated.... if i hit Ctrl-C then the booting
> proceeds normally. this doesn't happen with 2.6.38) so probably this bug
> can be closed.

Thanks, closing.

Rafael
