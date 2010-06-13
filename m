Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0FMO5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 10:57:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab0FMO5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:57:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.Cg.T7OFMB@chimera>
Subject: [Bug #15858] [2.6.34-rc5] bad page state copying to/from HFS+ filesystem...
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jun 2010 16:48:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15858
Subject		: [2.6.34-rc5] bad page state copying to/from HFS+ filesystem...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2010-04-25 21:14 (50 days old)
Message-ID	: <v2k6278d2221004251414kbbcc41baw78b86120d81dce7d@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127223008621881&w=2


