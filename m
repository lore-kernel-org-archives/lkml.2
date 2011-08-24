Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1HXRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:25:56 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58304 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752670Ab1HXRZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:25:53 -0400
Date: Wed, 24 Aug 2011 10:25:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jason Baron <jbaron@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 24 (dynamic_debug)
Message-Id: <20110824102551.8fc076b5.rdunlap@xenotime.net>
In-Reply-To: <20110824160404.ebad6370aee2cad82a990142@canb.auug.org.au>
References: <20110824160404.ebad6370aee2cad82a990142@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 16:04:04 +1000 Stephen Rothwell wrote:

> Hi all,

When CONFIG_NET is not enabled (I see this on i386 builds):

lib/built-in.o: In function `__dynamic_netdev_dbg':
(.text+0x9fda): undefined reference to `__netdev_printk'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
