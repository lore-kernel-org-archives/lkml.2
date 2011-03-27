Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1C0UsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 16:48:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1C0UrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 16:47:06 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Sean Noonan" <Sean.Noonan@twosigma.com>
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
In-Reply-To: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <40UNry85rJN.A.EhD.Dn5jNB@chimera>
Subject: [Bug #31982] XFS memory allocation deadlock in 2.6.38
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 27 Mar 2011 22:27:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.37.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31982
Subject		: XFS memory allocation deadlock in 2.6.38
Submitter	: Sean Noonan <Sean.Noonan@twosigma.com>
Date		: 2011-03-21 16:19 (7 days old)
Message-ID	: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
References	: http://marc.info/?l=linux-kernel&m=130072585111310&w=2


