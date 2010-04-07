Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0DGVva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:51:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37832 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab0DGVvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:51:17 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andrew Benton" <b3nton@gmail.com>, "Jeff Garzik" <jeff@garzik.org>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
In-Reply-To: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <JVS2s9dmTsP.A.g3F.4sPvLB@chimera>
Subject: [Bug #15716] ata2: lost interrupt with kernel 2.6.34-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  7 Apr 2010 23:13:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15716
Subject		: ata2: lost interrupt with kernel 2.6.34-rc1
Submitter	: Andrew Benton <b3nton@gmail.com>
Date		: 2010-03-11 16:57 (28 days old)
Message-ID	: <4B992110.2090300@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126832670609705&w=4
Handled-By	: Jeff Garzik <jeff@garzik.org>


