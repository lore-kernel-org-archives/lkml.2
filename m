Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2G0C2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 22:28:17 -0400
Received: from lunge.queued.net ([173.255.254.236]:35615 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2G0C2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 22:28:14 -0400
Date: Thu, 26 Jul 2012 19:28:03 -0700
From: Andres Salomon <dilinger@queued.net>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/olpc_dcon: fix checkpatch warnings
Message-ID: <20120726192803.0afb7eb2@debxo>
In-Reply-To: <1343346559-8416-1-git-send-email-yamanetoshi@gmail.com>
References: <1343346559-8416-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012 08:49:19 +0900
Toshiaki Yamane <yamanetoshi@gmail.com> wrote:

> Now checkpatch clean.
> 
> $ find drivers/staging/olpc_dcon/ -name
> "*.[ch]"|xargs ./scripts/checkpatch.pl \ -f --terse --nosummary|cut
> -f3- -d":"|sort |uniq -c|sort -n 2  WARNING: msleep < 20ms can sleep
> for up to 20ms; see Documentation/timers/timers-howto.txt 3  WARNING:

NACK - please don't modify the msleep timings right now.  The pr_*
changes are welcome, however.


> Prefer pr_debug(... to printk(KERN_DEBUG, ... 3  WARNING: Prefer
> pr_warn(... to printk(KERN_WARNING, ... 6  WARNING: Prefer
> pr_info(... to printk(KERN_INFO, ... 19  WARNING: Prefer pr_err(...
> to printk(KERN_ERR, ...
> 
> And added pr_fmt.
> 
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
[...]
