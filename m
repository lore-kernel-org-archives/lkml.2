Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0HaMMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:12:42 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:49760 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598Ab0HaMMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:12:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [00/12] DMAENGINE: PL08X driver updates
Date: Tue, 31 Aug 2010 14:12:02 +0200
Message-ID: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

This updates the PL08X driver in the async_tx next branch with
a number of fixes and features, each one pretty self-describing.
This has been tested with the PrimeCell DMA series on the
RealView PB11MPCore and works flawlessly, multiplexing
several virtual clients, both devices (slaves) and memcpy
channels, across only two (!) available physical channels.

If you prefer you can squash these into the initial driver
submission, I don't mind.

Yours,
Linus Walleij

