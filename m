Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab0GMFEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:04:46 -0400
Received: from mail.perches.com ([173.55.12.10]:1851 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab0GMFEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:04:45 -0400
Subject: Re: [PATCH 16/36] drivers/sbus: Remove unnecessary casts of
 private_data
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100712.211856.24591640.davem@davemloft.net>
References: <cover.1278967120.git.joe@perches.com>
	 <135e39325e4dd5c7fc4ac9481575ab03c6ce04f6.1278967121.git.joe@perches.com>
	 <20100712.211856.24591640.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 22:04:42 -0700
Message-ID: <1278997482.1501.368.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 21:18 -0700, David Miller wrote:
> Looks like we need a pattern for drivers/sbus in MAINTAINERS, I'll add it.

Oh good, thanks.

Unsurprisingly, it looks like it should be you...

$ git log --format=%an drivers/sbus  | sort | uniq -c | sort -rn | head -5
     54 David S. Miller
     12 Christoph Hellwig
     11 Arnd Bergmann
     11 Al Viro
      6 Tejun Heo


