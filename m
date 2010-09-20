Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0ITNDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:03:07 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:48896 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0ITNDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:03:04 -0400
Subject: Re: [RFC] jffs2: use cond_resched() instead of yield()
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1283357021-16187-1-git-send-email-w.sang@pengutronix.de>
References: <1283357021-16187-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 20 Sep 2010 16:00:59 +0300
Message-ID: <1284987659.5258.43.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 18:03 +0200, Wolfram Sang wrote:
> yield() has different semantics meanwhile and even causes RT-kernels to
> BUG. Replace the only appearance left in jffs2.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Ingo Molnar <mingo@elte.hu>

FYI, I've pushed this patch to my l2-mtd-2.6.git tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

