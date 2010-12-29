Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0L2XP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:15:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab0L2XPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:15:24 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Tobias" <devnull@plzk.org>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
In-Reply-To: <96DQe4a_2tH.A.4RE.497GNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sV7shrPOroO.A.BBH.dA8GNB@chimera>
Subject: [Bug #22642] 2.6.37-rc1: Disk takes 10 seconds to resume - MacBook2,1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Dec 2010 00:06:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22642
Subject		: 2.6.37-rc1: Disk takes 10 seconds to resume - MacBook2,1
Submitter	: Tobias <devnull@plzk.org>
Date		: 2010-11-10 19:33 (50 days old)


