Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0DDOya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:54:30 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52031 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0DDOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:54:24 -0400
Date: Sun, 4 Apr 2010 16:54:23 +0200
From: Andreas Mohr <andi@lisas.de>
To: Karsten Keil <kkeil@novell.com>
Cc: Andreas Eversberg <jolly@eversberg.eu>, linux-kernel@vger.kernel.org
Subject: [BUG] mISDN hfcpci.c _and_ several others: module reference count
	underflow
Message-ID: <20100404145423.GA14719@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

hfcpci.c seems to be missing active checking against extra
submissions of CLOSE_CHANNEL operations, causing an underflow
due to re-doing things.

Just filed a report at
https://bugzilla.kernel.org/show_bug.cgi?id=15691

Thanks,

Andreas Mohr
