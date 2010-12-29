Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0L2XRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:17:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40243 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab0L2XRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:17:25 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Gurudas Pai" <gurudas.pai@oracle.com>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
In-Reply-To: <96DQe4a_2tH.A.4RE.497GNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sV7shrPOroO.A.zZE._97GNB@chimera>
Subject: [Bug #25822] [BUG] kernel BUG at mm/truncate.c:479! on 2.6.37-rc8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Dec 2010 00:07:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25822
Subject		: [BUG] kernel BUG at mm/truncate.c:479! on 2.6.37-rc8
Submitter	: Gurudas Pai <gurudas.pai@oracle.com>
Date		: 2010-12-29 6:58 (1 days old)
Message-ID	: <4D1AD935.1020504@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=129360511222037&w=2


