Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1GFVuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:50:32 -0400
Received: from mail.perches.com ([173.55.12.10]:3617 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab1GFVub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:50:31 -0400
Subject: Re: [PATCH 07/10] dynamic_debug: make netdev_dbg() call
 __netdev_printk()
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org
In-Reply-To: <2ac0aaf4e955209cfad896c72fdb6b1491b021e1.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
References: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
	 <2ac0aaf4e955209cfad896c72fdb6b1491b021e1.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 14:50:29 -0700
Message-ID: <1309989029.1710.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 13:25 -0400, Jason Baron wrote:
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
[]
> @@ -503,6 +504,30 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
[]
> +int __dynamic_netdev_dbg(struct _ddebug *descriptor,
> +		      const struct net_device *dev, const char *fmt, ...)
[]
> +	res += __netdev_printk("", dev, &vaf);

KERN_CONT here too.


