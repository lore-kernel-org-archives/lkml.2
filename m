Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1D3Twy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 15:52:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851Ab1D3TvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 15:51:23 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Dave Jones" <davej@redhat.com>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
In-Reply-To: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <G9uL1cldhmL.A.YOE.hVGvNB@chimera>
Subject: [Bug #33792] lockdep trace when unplugging usb audio (.39rc4)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Apr 2011 21:46:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.38.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33792
Subject		: lockdep trace when unplugging usb audio (.39rc4)
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2011-04-19 18:07 (12 days old)
Message-ID	: <20110419180745.GA438@redhat.com>
References	: http://marc.info/?l=linux-kernel&m=130323648920431&w=2


