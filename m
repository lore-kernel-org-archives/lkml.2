Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2BWXOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:14:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39732 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341Ab2BWXNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:13:39 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Josh Boyer" <jwboyer@redhat.com>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
In-Reply-To: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qCQH7HfZS8E.A.PVF.u8rRPB@chimera>
Subject: [Bug #42746] 3.3-rc2 snd_pcm lockdep backtrace
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 23:55:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.2.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42746
Subject		: 3.3-rc2 snd_pcm lockdep backtrace
Submitter	: Josh Boyer <jwboyer@redhat.com>
Date		: 2012-02-06 14:56 (18 days old)
Message-ID	: <20120206145621.GA4771@zod.bos.redhat.com>
References	: http://marc.info/?l=linux-kernel&m=132854040916172&w=2


