Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0FUSnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:43:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34547 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab0FUSnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:43:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: [Bug #16178] 2.6.35-rc2 : OOPS with LTP memcg regression test run.
Date: Mon, 21 Jun 2010 20:41:47 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera> <W8JfMs9cZw.A.O8F.UNpHMB@chimera> <4C1EEE54.9000902@in.ibm.com>
In-Reply-To: <4C1EEE54.9000902@in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006212041.47967.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 21, 2010, Sachin Sant wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >   
> This has been fixed by commit 386f40.
> This was yet another instance of memory corruption caused by issue
> related to ASCII while space pattern.

Thanks, closing.

Rafael
