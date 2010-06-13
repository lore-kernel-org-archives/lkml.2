Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0FMO5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 10:57:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab0FMO4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:56:47 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.VjB.s8OFMB@chimera>
Subject: [Bug #15669] INFO: suspicious rcu_dereference_check()
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15669
Subject		: INFO: suspicious rcu_dereference_check()
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2010-03-08 1:26 (98 days old)
Message-ID	: <c4e36d111003250348q678eb2e6w4f3e8133e7fd6e58@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126801163107713&w=2


