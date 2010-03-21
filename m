Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0CUVEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:04:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59511 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0CUVCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:02:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "=?utf-8?q?Am=C3=A9rico=20Wang?=" <xiyou.wangcong@gmail.com>,
       "M G Berberich" <berberic@fmi.uni-passau.de>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
In-Reply-To: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hTwaxgnIZ2O.A.Q1D.XOopLB@chimera>
Subject: [Bug #15466] 2.6.33 dies on modprobe
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Mar 2010 21:30:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.32 and 2.6.33.

The following bug entry is on the current list of known regressions
introduced between 2.6.32 and 2.6.33.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15466
Subject		: 2.6.33 dies on modprobe
Submitter	: M G Berberich <berberic@fmi.uni-passau.de>
Date		: 2010-02-28 22:12 (22 days old)
Message-ID	: <20100228221257.GA8858@invalid>
References	: http://marc.info/?l=linux-kernel&m=126739570819208&w=2
Handled-By	: Américo Wang <xiyou.wangcong@gmail.com>


