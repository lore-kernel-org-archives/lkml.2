Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0FMO7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 10:59:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58906 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab0FMO7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:59:07 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Richard Zidlicky" <rz@linux-m68k.org>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.LtG.v5OFMB@chimera>
Subject: [Bug #16134] 2.6.34 hard lock ppp/do_tty_hangup, regression
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16134
Subject		: 2.6.34 hard lock ppp/do_tty_hangup, regression
Submitter	: Richard Zidlicky <rz@linux-m68k.org>
Date		: 2010-05-26 8:48 (19 days old)
Message-ID	: <20100526084811.GA5890@linux-m68k.org>
References	: http://marc.info/?l=linux-kernel&m=127486354023473&w=2


