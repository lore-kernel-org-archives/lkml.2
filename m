Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2EHQYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:24:12 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:45842 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754666Ab2EHQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:24:10 -0400
Message-ID: <4FA948B9.20600@xenotime.net>
Date: Tue, 08 May 2012 09:24:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kay@vrfy.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for May 8 (printk)
References: <20120508181531.072fdc5fefa60d852e784587@canb.auug.org.au>
In-Reply-To: <20120508181531.072fdc5fefa60d852e784587@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 01:15 AM, Stephen Rothwell wrote:

> Hi all,
> 
> There will be no linux-next tomorrow.
> 
> Changes since 20120507:


Build errors on i386 and x86_64 when CONFIG_PRINTK is not enabled:

drivers/char/mem.c:858:2: error: implicit declaration of function 'printk_emit'

kernel/printk.c:1423:20: error: 'LOG_LINE_MAX' undeclared (first use in this function)
kernel/printk.c:1427:3: error: 'logbuf_lock' undeclared (first use in this function)
kernel/printk.c:1428:19: error: 'log_next_seq' undeclared (first use in this function)
kernel/printk.c:1433:21: error: 'log_first_seq' undeclared (first use in this function)
kernel/printk.c:1436:18: error: 'log_first_idx' undeclared (first use in this function)
kernel/printk.c:1442:3: error: implicit declaration of function 'log_from_idx'
kernel/printk.c:1442:7: warning: assignment makes pointer from integer without a cast
kernel/printk.c:1443:14: error: dereferencing pointer to incomplete type
kernel/printk.c:1444:12: error: dereferencing pointer to incomplete type
kernel/printk.c:1447:3: error: implicit declaration of function 'log_text'
kernel/printk.c:1450:3: error: implicit declaration of function 'log_next'
kernel/printk.c:1711:3: error: 'logbuf_lock' undeclared (first use in this function)
kernel/printk.c:1712:17: error: 'syslog_seq' undeclared (first use in this function)
kernel/printk.c:1713:17: error: 'syslog_idx' undeclared (first use in this function)



-- 
~Randy
