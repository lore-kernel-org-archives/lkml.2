Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1FFKYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:24:30 -0400
Received: from smtp.nokia.com ([147.243.1.47]:58297 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab1FFKY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:24:27 -0400
Subject: Re: [PATCH] mtd: mtdblock: Use DEFINE_MUTEX() for mtdblks_lock
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org,
        Matthias Kaehlcke <matthias@kaehlcke.net>
In-Reply-To: <1307081422.6450.2.camel@phoenix>
References: <1307081422.6450.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 06 Jun 2011 13:20:01 +0300
Message-ID: <1307355601.3112.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 14:10 +0800, Axel Lin wrote:
> mtdblks_lock can be initialized automatically with
> DEFINE_MUTEX() rather than explicitly calling mutex_init().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

