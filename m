Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0IZU75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 16:59:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43119 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab0IZU7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 16:59:55 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "zersaa" <zersaa@gmail.com>
References: <onxdOCF6lb.A.vKB.a_6nMB@chimera>
In-Reply-To: <onxdOCF6lb.A.vKB.a_6nMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UfOptYFtL6C.A.9WC.UA7nMB@chimera>
Subject: [Bug #17772] Unable to locate IOAPIC for GSI *
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Sep 2010 22:33:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17772
Subject		: Unable to locate IOAPIC for GSI *
Submitter	: zersaa <zersaa@gmail.com>
Date		: 2010-09-04 21:28 (23 days old)


