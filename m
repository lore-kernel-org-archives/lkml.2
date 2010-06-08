Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab0FHWTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:19:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39685 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab0FHWQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:16:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
In-Reply-To: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <C9Q3XEnHPeG.A.gdG.f8rDMB@chimera>
Subject: [Bug #16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Jun 2010 00:10:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16122
Subject		: 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2010-06-04 13:18 (5 days old)


