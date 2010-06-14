Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab0FNVwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:52:12 -0400
Received: from xenotime.net ([72.52.115.56]:57210 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756667Ab0FNVwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:52:10 -0400
Date: Mon, 14 Jun 2010 14:52:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15970] BUG: amd64-agp (2.6.34-rc7)
Message-Id: <20100614145204.af3fd160.rdunlap@xenotime.net>
In-Reply-To: <YPGdyfWGvNK.A.ykH.g6OFMB@chimera>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
	<YPGdyfWGvNK.A.ykH.g6OFMB@chimera>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jun 2010 16:48:59 +0200 (CEST) Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15970
> Subject		: BUG: amd64-agp (2.6.34-rc7)
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2010-05-11 20:56 (34 days old)
> Message-ID	: <4BE9C469.2020901@oracle.com>
> References	: http://marc.info/?l=linux-kernel&m=127361149610881&w=2


This bug does not happen in 2.6.35-rc3; it appears that some patch has
fixed this one.  Please close it as fixed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
