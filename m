Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0FTWqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:46:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58872 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505Ab0FTWp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:45:58 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Borislav Petkov" <bp@alien8.de>,
       "Parag Warudkar" <parag.lkml@gmail.com>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rHrHQMIU4rI.A.h6.rapHMB@chimera>
Subject: [Bug #16054] UML broken for CONFIG_SLAB
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jun 2010 00:34:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16054
Subject		: UML broken for CONFIG_SLAB
Submitter	: Parag Warudkar <parag.lkml@gmail.com>
Date		: 2010-05-23 21:40 (29 days old)
Message-ID	: <alpine.DEB.2.00.1005231149100.605@parag-laptop>
References	: http://marc.info/?l=linux-kernel&m=127465083806617&w=2
Handled-By	: Borislav Petkov <bp@alien8.de>
Patch		: http://git.kernel.org/tip/055c47272b8f5679d08ccc57efea3cb4aaeb5fc6


