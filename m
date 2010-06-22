Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab0FVVuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:50:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0FVVui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:50:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [Bug #15863] 2.6.34-rc5-git7 (plus all patches) -- another suspicious rcu_dereference_check() usage.
Date: Tue, 22 Jun 2010 23:49:12 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Miles Lane <miles.lane@gmail.com>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera> <rHrHQMIU4rI.A.E9B.QcpHMB@chimera> <20100622211135.GO2290@linux.vnet.ibm.com>
In-Reply-To: <20100622211135.GO2290@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006222349.13096.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010, Paul E. McKenney wrote:
> On Mon, Jun 21, 2010 at 12:34:25AM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.33 and 2.6.34.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> 
> We have been knocking these off as they appear.  There is one or two
> that the relevant maintainers have been ignoring, but that always seems
> to be the case.  ;-)
> 
> Your choice as to whether you want to track the group...

I think I'll simply leave that one bug open until all known instances have been
dealt with.

Please let me know when that happens. :-)

Thanks,
Rafael
