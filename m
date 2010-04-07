Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0DGVwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:52:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37825 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab0DGVvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:51:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Boaz Harrosh" <bharrosh@panasas.com>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
In-Reply-To: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <JVS2s9dmTsP.A.ApF.zsPvLB@chimera>
Subject: [Bug #15718] File corruption regression on NFS related to commit 1f36f774
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15718
Subject		: File corruption regression on NFS related to commit 1f36f774
Submitter	: Boaz Harrosh <bharrosh@panasas.com>
Date		: 2010-03-24 15:49 (15 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/1f36f774b22a0ceb7dd33eca626746c81a97b6a5
Message-ID	: <4BAA3493.1030802@panasas.com>
References	: http://marc.info/?l=linux-kernel&m=126944579810350&w=4
Handled-By	: Al Viro <viro@zeniv.linux.org.uk>


