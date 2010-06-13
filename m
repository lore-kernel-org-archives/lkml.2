Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0FMPBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:01:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58899 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab0FMO7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:59:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Renninger" <trenn@suse.de>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.KnG.t5OFMB@chimera>
Subject: [Bug #16135] [BUG] kacpi_notify goes into an infinite loop (luckly it calls cond_resched)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jun 2010 16:49:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16135
Subject		: [BUG] kacpi_notify goes into an infinite loop (luckly it calls cond_resched)
Submitter	: Steven Rostedt <rostedt@goodmis.org>
Date		: 2010-05-29 1:01 (16 days old)
First-Bad-Commit: http://git.kernel.org/linus/fa80945269f312bc609e8384302f58b03c916e12
Message-ID	: <1275094882.22648.607.camel@gandalf.stny.rr.com>
References	: http://marc.info/?l=linux-kernel&m=127509490405845&w=2


