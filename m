Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2GKFpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:45:22 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56681 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753326Ab2GKFpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:45:21 -0400
Message-ID: <4FFD12C5.9090204@xenotime.net>
Date: Tue, 10 Jul 2012 22:44:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: linux-next: Tree for July 10 (gpio/gpio-tps65910.c)
References: <20120710174320.3b7dd806e20ee74ca1b1685f@canb.auug.org.au>
In-Reply-To: <20120710174320.3b7dd806e20ee74ca1b1685f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 12:43 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120709:
> 



on i386:

when CONFIG_OF_GPIO is not enabled:

drivers/gpio/gpio-tps65910.c: In function 'tps65910_gpio_probe':
drivers/gpio/gpio-tps65910.c:152:26: error: 'struct gpio_chip' has no member named 'of_node'



-- 

~Randy
