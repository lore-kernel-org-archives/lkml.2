Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab0GHX7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:59:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37925 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935Ab0GHX6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:58:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "David Safford" <safford@watson.ibm.com>,
       "Helmut Schaa" <helmut.schaa@googlemail.com>,
       "James Morris" <jmorris@namei.org>,
       "Rajiv Andrade" <srajiv@linux.vnet.ibm.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.QYC.1MmNMB@chimera>
Subject: [Bug #16256] tpm_tis breaks suspend/hibernate on kernels > 2.6.34
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16256
Subject		: tpm_tis breaks suspend/hibernate on kernels > 2.6.34
Submitter	: Helmut Schaa <helmut.schaa@googlemail.com>
Date		: 2010-06-20 11:15 (19 days old)
First-Bad-Commit: http://git.kernel.org/linus/225a9be24d799aa16d543c31fb09f0c9ed1d9caa
Handled-By	: Helmut Schaa <helmut.schaa@googlemail.com>
Patch		: http://marc.info/?l=tpmdd-devel&m=127609160616162&w=2


