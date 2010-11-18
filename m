Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab0KRX5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:57:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab0KRX5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:57:09 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Randy Dunlap" <randy.dunlap@oracle.com>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
In-Reply-To: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ATV3yiK8i4C.A.07E.dib5MB@chimera>
Subject: [Bug #22282] 2.6.37-rc1: WARNING..debugobjects: ODEBUG: free active (active state 0) object type: percpu_counter
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22282
Subject		: 2.6.37-rc1: WARNING..debugobjects: ODEBUG: free active (active state 0) object type: percpu_counter
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2010-11-01 21:58 (18 days old)
Message-ID	: <4CCF37E8.1070208@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=128864879328429&w=2


