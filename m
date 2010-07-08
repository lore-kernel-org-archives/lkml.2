Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab0GIAAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:00:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38019 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab0GIAAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:00:25 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "werner@guyane.yi.org"@ogre.sisk.pl
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.vd.0LmNMB@chimera>
Subject: [Bug #16332] Kernel crashes in tty code (tty_open)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16332
Subject		: Kernel crashes in tty code (tty_open)
Submitter	: werner@guyane.yi.org
Date		: 2010-07-02 3:34 (7 days old)
Message-ID	: <1278041650.12788@guyane.yi.org>
References	: http://marc.info/?l=linux-kernel&m=127804167511930&w=2


