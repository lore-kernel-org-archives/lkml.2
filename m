Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1HKTGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:06:14 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54820 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752912Ab1HKTGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:06:12 -0400
Date: Thu, 11 Aug 2011 11:59:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        rjw@sisk.pl
Subject: Re: linux-next: Tree for Aug 11 (suspend_stats build error)
Message-Id: <20110811115931.8007900d.rdunlap@xenotime.net>
In-Reply-To: <20110811162058.42b462bc80e67d7a80ecff93@canb.auug.org.au>
References: <20110811162058.42b462bc80e67d7a80ecff93@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011 16:20:58 +1000 Stephen Rothwell wrote:

> Hi all,

When CONFIG_PM_SLEEP is not enabled:

kernel/built-in.o: In function `suspend_stats_show':
main.c:(.text+0x40a25): undefined reference to `suspend_stats'
main.c:(.text+0x40a2c): undefined reference to `suspend_stats'
main.c:(.text+0x40a32): undefined reference to `suspend_stats'
main.c:(.text+0x40a73): undefined reference to `suspend_stats'
main.c:(.text+0x40a82): undefined reference to `suspend_stats'
kernel/built-in.o:main.c:(.text+0x40a91): more undefined references to `suspend_stats' follow


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
