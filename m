Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0DEWOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:14:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756439Ab0DEWON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:14:13 -0400
Date: Mon, 5 Apr 2010 15:12:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jiri Kosina <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] kernel.h: Convert rounding macros to statement
 expressions, add ADD_MOD
Message-Id: <20100405151259.7219c312.akpm@linux-foundation.org>
In-Reply-To: <1269901114.4558.47.camel@Joe-Laptop.home>
References: <1269813447.1500.69.camel@Joe-Laptop.home>
	<20100329124708.898b617c.randy.dunlap@oracle.com>
	<1269892842.4558.7.camel@Joe-Laptop.home>
	<1269896989.4558.18.camel@Joe-Laptop.home>
	<20100329144924.d00f0680.randy.dunlap@oracle.com>
	<1269901114.4558.47.camel@Joe-Laptop.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 15:18:34 -0700
Joe Perches <joe@perches.com> wrote:

> Convert rounding macros to statement expressions
> so arguments are only evaluated once.
> Add kernel-doc to rounding macros
> Add ADD_MOD statement expression for "(x + y) % y"

In file included from /usr/src/devel/arch/x86/include/asm/cpumask.h:4,
                 from /usr/src/devel/arch/x86/include/asm/msr.h:18,
                 from /usr/src/devel/arch/x86/include/asm/processor.h:21,
                 from /usr/src/devel/arch/x86/include/asm/atomic.h:6,
                 from include/linux/crypto.h:20,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/cpumask.h:13: error: braced-group within expression allowed only inside a function
include/linux/cpumask.h:13: warning: no semicolon at end of struct or union
include/linux/cpumask.h:13: error: syntax error before numeric constant
include/linux/cpumask.h:13: warning: type defaults to 'int' in declaration of 'cpumask_t'
include/linux/cpumask.h:13: warning: data definition has no type or storage class
...

Some sort of dependency tangle I guess.
