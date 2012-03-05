Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2CERp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:45:29 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37303 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753321Ab2CERpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:45:22 -0500
Message-ID: <4F54FBBC.5060809@xenotime.net>
Date: Mon, 05 Mar 2012 09:45:32 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: Tree for Mar 5 (of/irqs)
References: <20120305181024.d396adb4fefdf6d269657606@canb.auug.org.au>
In-Reply-To: <20120305181024.d396adb4fefdf6d269657606@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2012 11:10 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120302:



Still have both of these build errors (on i386/X86_32;
2 different builds):


drivers/mfd/twl-core.c:1262:2: error: implicit declaration of function 'irq_alloc_descs'
drivers/mfd/twl-core.c:1357:3: error: implicit declaration of function 'of_platform_populate'


and:

drivers/gpio/gpio-sodaville.c:130:2: error: unknown field 'dt_translate' specified in initializer
drivers/gpio/gpio-sodaville.c:130:2: warning: initialization from incompatible pointer type
drivers/gpio/gpio-sodaville.c:152:8: error: 'struct irq_domain' has no member named 'irq_base'
drivers/gpio/gpio-sodaville.c:182:2: error: implicit declaration of function 'irq_domain_add'
drivers/gpio/gpio-sodaville.c:263:2: error: implicit declaration of function 'irq_domain_del'




~Randy

