Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2KLWyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:54:11 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52327 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752157Ab2KLWyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:54:09 -0500
Message-ID: <1352760850.18715.8.camel@joe-AO722>
Subject: Re: [PATCH V2 00/23] printk: refactoring
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 14:54:10 -0800
In-Reply-To: <1351864140.3537.1.camel@joe-AO722>
References: <cover.1351135988.git.joe@perches.com>
	 <1351864140.3537.1.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 06:49 -0700, Joe Perches wrote:
> On Wed, 2012-10-24 at 20:43 -0700, Joe Perches wrote:
> > Make printk a bit more readable.
> 
> Andrew?  Are you going to apply this again for -next?

Andrew?  Any answer?

> > Created directory:
> > 	kernel/printk
> > Created source files:
> > 	printk.c		Generic printk and console routines
> > 	printk_log.[ch]		Log buffer routines
> > 	printk_syslog.[ch]	syslog(2) routines
> > 	braille.c		Braille console support
> > 	devkmsg.c		/dev/kmsg support
> > 	kmsg_dump.c		kmsg_dump support
> > 
> > Changes from v1:
> > Fix braille.h: _braille_console_setup return value
> > Remove duplicated #define
> > Add missing #include <linux/uaccess.h>
> 



