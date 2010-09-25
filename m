Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0IYMBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 08:01:03 -0400
Received: from crca.org.au ([74.207.252.120]:54843 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab0IYMBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 08:01:01 -0400
X-Bogosity: Ham, spamicity=0.000310
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Nigel's current for-rafael queue - one more patch.
Date: Sat, 25 Sep 2010 22:00:55 +1000
Message-Id: <1285416056-9735-1-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

This patch continues the series I posted earlier in the day, adding
readahead support that improves the speed of reading an image by a
similar factor (66MB/s -> 229MB/s).

Regards,

Nigel

