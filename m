Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076Ab0KSADT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:03:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34879 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567Ab0KRX5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:57:10 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Radu Andries" <admiral0@tuxfamily.org>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
In-Reply-To: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ATV3yiK8i4C.A.t1E.Zib5MB@chimera>
Subject: [Bug #22472] vga_switcheroo fails to switch from intel to ati
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 19 Nov 2010 00:42:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22472
Subject		: vga_switcheroo fails to switch from intel to ati
Submitter	: Radu Andries <admiral0@tuxfamily.org>
Date		: 2010-11-08 16:46 (11 days old)


