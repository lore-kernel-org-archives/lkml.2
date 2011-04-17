Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1DQNbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:31:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56744 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab1DQNbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:31:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [Bug #33252] [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper MSR register to catch" and NMIs
Date: Sun, 17 Apr 2011 15:31:36 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Shaun Ruffell <sruffell@digium.com>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.WiB.dGuqNB@chimera> <4DAAE5AA.1090302@gmail.com>
In-Reply-To: <4DAAE5AA.1090302@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104171531.36905.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 17, 2011, Cyrill Gorcunov wrote:
> On 04/17/2011 04:57 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.38.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33252
> > Subject		: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper MSR register to catch" and NMIs
> > Submitter	: Shaun Ruffell <sruffell@digium.com>
> > Date		: 2011-04-06 22:30 (12 days old)
> > 
> > 
> 
> We're working on it, patch is almost done. I guess it'll be published next week.

Great, thanks!  Please let me know when the patch makes it to the Linus' tree.

Rafael
