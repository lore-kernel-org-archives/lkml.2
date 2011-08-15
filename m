Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1HOIHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 04:07:49 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40704 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1HOIHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 04:07:46 -0400
Date: Mon, 15 Aug 2011 10:07:32 +0200
From: Florian Mickler <florian@mickler.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #37872] CPU lockup during boot
Message-ID: <20110815100732.32695233@schatten.dmk.lab>
In-Reply-To: <20110815023957.GA516@wolff.to>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.TRB.lOCSOB@chimera>
	<20110815023957.GA516@wolff.to>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Aug 2011 21:39:57 -0500
Bruno Wolff III <bruno@wolff.to> wrote:

> On Sun, Aug 14, 2011 at 21:07:31 +0200,
>   "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.39 and 3.0.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.39 and 3.0.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37872
> > Subject		: CPU lockup during boot
> > Submitter	: Bruno Wolff III <bruno@wolff.to>
> > Date		: 2011-06-19 15:00 (57 days old)
> > Patch		: https://bugzilla.kernel.org/show_bug.cgi?id=37872#c16
> 
> I am not sure of the correct procedure, but the issue was fixed just
> before the 3.0 release and the ticket is currently in the RESOLVED state.
> Should I change it to closed?

Just paste the sha1 of the commit that fixed it into the bugzilla and
switch it to 'closed/code fix'.

Regards,
Flo
