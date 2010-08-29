Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0H2WwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 18:52:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0H2WwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 18:52:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, "" <trapdoor6@gmail.com>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
In-Reply-To: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4AUWBNzTkbD.A.mj.QGueMB@chimera>
Subject: [Bug #16881] [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing textures in 0 A.D.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 00:36:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16881
Subject		: [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing textures in 0 A.D.
Submitter	:  <trapdoor6@gmail.com>
Date		: 2010-08-24 12:20 (6 days old)


