Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0H2WkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 18:40:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab0H2WkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 18:40:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Jarek Poplawski" <jarkao2@gmail.com>,
        "Jarek Poplawski" <jarkao2@gmail.com>,
        "Plamen Petrov" <pvp-lsts@fs.uni-ruse.bg>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
In-Reply-To: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4AUWBNzTkbD.A.ey.cGueMB@chimera>
Subject: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Aug 2010 00:24:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16626
Subject		: Machine hangs with EIP at skb_copy_and_csum_dev
Submitter	: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Date		: 2010-08-19 09:57 (11 days old)
Handled-By	:  Eric Dumazet <eric.dumazet@gmail.com>


