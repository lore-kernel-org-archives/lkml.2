Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab0HAN6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 09:58:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab0HAN6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 09:58:40 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Eric Sandeen" <sandeen@redhat.com>, "Phillip Susi" <psusi@cfl.rr.com>
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
In-Reply-To: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Aan7wZ97YaE.A.qfF.mrXVMB@chimera>
Subject: [Bug #16278] lvm snapshot causes deadlock in 2.6.35
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  1 Aug 2010 15:52:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16278
Subject		: lvm snapshot causes deadlock in 2.6.35
Submitter	: Phillip Susi <psusi@cfl.rr.com>
Date		: 2010-06-23 16:55 (40 days old)
Handled-By	: Eric Sandeen <sandeen@redhat.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=26933


