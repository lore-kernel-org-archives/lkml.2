Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab0KRX5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:57:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34882 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab0KRX5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:57:12 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Thomas Meyer" <thomas@m3y3r.de>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
In-Reply-To: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ATV3yiK8i4C.A.3tE.Tib5MB@chimera>
Subject: [Bug #22532] 2.6.37-rc1: BUG: scheduling while atomic (kvm_init)
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22532
Subject		: 2.6.37-rc1: BUG: scheduling while atomic (kvm_init)
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-11-02 19:06 (17 days old)
Message-ID	: <50AA24C585B14210A44AB599605C7CBD@hugo>
References	: http://marc.info/?l=linux-kernel&m=128872479921559&w=2


