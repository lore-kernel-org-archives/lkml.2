Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0CUVDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:03:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59536 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0CUVDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:03:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Sanjoy Mahajan" <sanjoy@mit.edu>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
In-Reply-To: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hTwaxgnIZ2O.A.PPD.5NopLB@chimera>
Subject: [Bug #15544] black screen upon S3 resume, syslog has "render error" and "page table error"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Mar 2010 21:30:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.32 and 2.6.33.

The following bug entry is on the current list of known regressions
introduced between 2.6.32 and 2.6.33.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15544
Subject		: black screen upon S3 resume, syslog has "render error" and "page table error"
Submitter	: Sanjoy Mahajan <sanjoy@mit.edu>
Date		: 2010-03-16 00:45 (6 days old)


