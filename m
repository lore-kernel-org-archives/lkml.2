Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1DQNyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:54:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56904 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab1DQNxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:53:02 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Sean Noonan" <Sean.Noonan@twosigma.com>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera>
In-Reply-To: <sam8u5dLkaB.A.afE.53uqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <IqJL5EkbqD.A.G3E.M4uqNB@chimera>
Subject: [Bug #31982] XFS memory allocation deadlock in 2.6.38
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 15:52:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31982
Subject		: XFS memory allocation deadlock in 2.6.38
Submitter	: Sean Noonan <Sean.Noonan@twosigma.com>
Date		: 2011-03-21 16:19 (28 days old)
Message-ID	: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
References	: http://marc.info/?l=linux-kernel&m=130072585111310&w=2


