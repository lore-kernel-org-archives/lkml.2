Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0FMO4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 10:56:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58795 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab0FMO4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:56:47 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Thomas Meyer" <thomas@m3y3r.de>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.nVB.m8OFMB@chimera>
Subject: [Bug #15673] 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jun 2010 16:48:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15673
Subject		: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-03-28 11:31 (78 days old)
Message-ID	: <1269775909.5301.4.camel@localhost.localdomain>
References	: http://marc.info/?l=linux-kernel&m=126977593326800&w=2


