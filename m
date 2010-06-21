Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0FUF5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 01:57:39 -0400
Received: from bamako.nerim.net ([62.4.17.28]:59425 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0FUF5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 01:57:36 -0400
Date: Mon, 21 Jun 2010 07:57:33 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the i2c tree
Message-ID: <20100621075733.5904b461@hyperion.delvare>
In-Reply-To: <20100621120331.1c6c1754.sfr@canb.auug.org.au>
References: <20100621120331.1c6c1754.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 12:03:31 +1000, Stephen Rothwell wrote:
> Hi Jean,
> 
> After merging the i2c tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/i2c/i2c-core.c: In function 'i2c_detect':
> drivers/i2c/i2c-core.c:1460: error: 'adap' undeclared (first use in this function)

Oops, sorry, forgot to refresh the patch before pushing it. This is
fixed now.

> Caused by commit b741e61eb906816f78acbf361797fd408abdc715 ("i2c: Fix
> probability check").  The typo in this patch is probably why the later
> patch that I dropped would not apply ...

You are correct.

> I have used the i2c tree form next-20100618 for today.


-- 
Jean Delvare
