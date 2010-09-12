Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0ILTcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:32:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab0ILT2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:28:52 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Alexey Fisher" <bug-track@fisher-privat.net>
References: <QnCvudbe2FD.A.XiE.DgSjMB@chimera>
In-Reply-To: <QnCvudbe2FD.A.XiE.DgSjMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <p44oKaOqEDM.A.7fF.KhSjMB@chimera>
Subject: [Bug #16532] random suspend (S3) problems on Intel DG45ID board
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Sep 2010 21:08:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16532
Subject		: random suspend (S3) problems on Intel DG45ID board
Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
Date		: 2010-08-07 08:55 (37 days old)


