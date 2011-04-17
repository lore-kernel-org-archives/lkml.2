Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1DQNwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:52:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab1DQNwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:52:21 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Justin Mattock" <justinmattock@gmail.com>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera>
In-Reply-To: <sam8u5dLkaB.A.afE.53uqNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <IqJL5EkbqD.A.5nF.F5uqNB@chimera>
Subject: [Bug #30582] WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda [ath9k]()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 17 Apr 2011 15:52:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.37 and 2.6.38.

The following bug entry is on the current list of known regressions
introduced between 2.6.37 and 2.6.38.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30582
Subject		: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536 ath_stoprecv+0xc8/0xda [ath9k]()
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2011-03-03 5:47 (46 days old)
Message-ID	: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129913127722786&w=2


