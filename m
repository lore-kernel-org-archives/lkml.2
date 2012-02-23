Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2BWXNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:13:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39705 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092Ab2BWXNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:13:02 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?J=C3=A9r=C3=B4me=20Glisse?=" <glisse@freedesktop.org>,
        "Torsten Kaiser" <just.for.lkml@googlemail.com>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
In-Reply-To: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qCQH7HfZS8E.A.UOG.H9rRPB@chimera>
Subject: [Bug #42678] [3.3-rc1] radeon stuck in kernel after lockup
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 23:55:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.2.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42678
Subject		: [3.3-rc1] radeon stuck in kernel after lockup
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2012-01-21 19:03 (34 days old)
Message-ID	: <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=132717279606670&w=2
Handled-By	: Jérôme Glisse <glisse@freedesktop.org>


