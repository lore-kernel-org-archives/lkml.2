Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab1CYQKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:10:54 -0400
Received: from smtp.nokia.com ([147.243.128.24]:44833 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab1CYQKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:10:53 -0400
Subject: Re: [GIT PULL] MTD changes for 2.6.39
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20110325161006.5639.95105.sendpatchset@localhost.localdomain>
References: <20110325161006.5639.95105.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 25 Mar 2011 18:08:17 +0200
Message-ID: <1301069297.2749.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 18:10 +0200, Artem Bityutskiy wrote:
>  arch/cris/Kconfig                            |    1 -
>  arch/cris/arch-v10/drivers/axisflashmap.c    |    6 -
>  arch/cris/arch-v32/drivers/Kconfig           |    1 -
>  arch/cris/arch-v32/drivers/axisflashmap.c    |    6 - 

And in case you wonder, these CRIS changes were agreed to go via the MTD
tree with the CRIS maintainer.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

