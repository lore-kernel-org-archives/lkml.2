Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2BWXNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:13:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39719 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab2BWXNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:13:37 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
In-Reply-To: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qCQH7HfZS8E.A.QbF.x8rRPB@chimera>
Subject: [Bug #42735] kobject (ffff88003ffbb4b8): tried to init an initialized object, something is seriously wrong.
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42735
Subject		: kobject (ffff88003ffbb4b8): tried to init an initialized object, something is seriously wrong.
Submitter	: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date		: 2012-02-03 20:59 (21 days old)
Message-ID	: <20120203205953.GA2897@phenom.dumpdata.com>
References	: http://marc.info/?l=linux-kernel&m=132830315526901&w=2


