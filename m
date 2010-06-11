Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab0FKP0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:26:34 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:51092 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab0FKP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:26:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
       <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 00/13] PrimeCell DMA API and drivers v6
Date: Fri, 11 Jun 2010 17:26:15 +0200
Message-ID: <1276269975-1191-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the sixth iteration of this patch set for PrimeCell
DMA support, reposting the entire series.

Since Russell want this to run on the Versatile boards, I
have hacked around with Peter Pearse's DMA driver for PL08x
and now it is starting to look usable. Still it doesn't work
with the PB1176 (because the DMA hardware is broken) and not
with the PB11MPCore for anything but memcpy (for unknown
reason slave DMA fails, possibly my stupidity).

I need help to test and try to iron out the final problems
with the RealView+Versatile DMA. The PL08x driver is long
due, it's used in Nomadik and SPEAr as well, with more
platforms waiting in the perimeter.

This entire series should probably be considered RFC even
though everything is well tested on U300 and U8500, since
the Versatile implementation gatekeeps the others.

Yours,
Linus Walleij
