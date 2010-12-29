Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0L2Xdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:33:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40366 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab0L2Xae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:30:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Jan Kara" <jack@suse.cz>,
        "" <markus.gapp@gmx.net>
References: <odW4v9b6arG.A.2bH.uE8GNB@chimera>
In-Reply-To: <odW4v9b6arG.A.2bH.uE8GNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LbeBv-BNQpL.A.aM.5F8GNB@chimera>
Subject: [Bug #21092] Kernel 2.6.36 Bug during quotaon on reiserfs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Dec 2010 00:21:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.35 and 2.6.36.

The following bug entry is on the current list of known regressions
introduced between 2.6.35 and 2.6.36.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=21092
Subject		: Kernel 2.6.36 Bug during quotaon on reiserfs
Submitter	:  <markus.gapp@gmx.net>
Date		: 2010-10-24 16:57 (67 days old)
Handled-By	: Jan Kara <jack@suse.cz>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=35292


