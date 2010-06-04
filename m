Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab0FDQ5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:57:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41145 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0FDQ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:57:46 -0400
Date: Fri, 4 Jun 2010 09:56:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 4 (mac80211)
Message-Id: <20100604095651.5f59119e.randy.dunlap@oracle.com>
In-Reply-To: <20100604153006.fa15c770.sfr@canb.auug.org.au>
References: <20100604153006.fa15c770.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C093086.002C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 15:30:06 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100603:
> 
> My fixes tree contains:
>       v4l-dvb: update gfp/slab.h includes
>       arm: update gfp/slab.h includes
>       davinci: update gfp/slab.h includes
>       ocfs2: update gfp/slab.h includes
>       acpi: update gfp/slab.h includes
> 
> The wireless tree gained a conflict against the net tree.
> 
> The rr tree gained a build failure for which I applied a patch.


when CONFIG_INET is not enabled:


ERROR: "register_inetaddr_notifier" [net/mac80211/mac80211.ko] undefined!
ERROR: "unregister_inetaddr_notifier" [net/mac80211/mac80211.ko] undefined!

or

(.text+0xb9585): undefined reference to `unregister_inetaddr_notifier'
(.text+0xb9b84): undefined reference to `register_inetaddr_notifier'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
