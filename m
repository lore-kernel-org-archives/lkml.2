Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868Ab2I2UIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 16:08:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46836 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750760Ab2I2UId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 16:08:33 -0400
Message-ID: <1348949312.3294.0.camel@joe-AO722>
Subject: Re: [PATCH 1/4] arch/um/drivers: Drop UM_ prefix from printk()
 level specifiers
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Sat, 29 Sep 2012 13:08:32 -0700
In-Reply-To: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
References: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-29 at 19:07 +0200, Geert Uytterhoeven wrote:
> Since commit 9429ec96c2718c0d1e3317cf60a87a0405223814 ("um: Preinclude
> include/linux/kern_levels.h") the non-prefixed printk() level specifiers
> are usable for the user parts of UML.


Thanks Geert.


