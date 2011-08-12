Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab1HLU4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 16:56:22 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:54023 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751331Ab1HLU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 16:56:20 -0400
Date: Fri, 12 Aug 2011 13:56:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sathya Perla <sathya.perla@emulex.com>,
        Subbu Seetharaman <subbu.seetharaman@emulex.com>,
        Ajit Khaparde <ajit.khaparde@emulex.com>
Subject: Re: linux-next: Tree for Aug 12 (benet/be2net)
Message-Id: <20110812135618.a209d9af.rdunlap@xenotime.net>
In-Reply-To: <20110812171311.4d7bb640f38838bf7c34df50@canb.auug.org.au>
References: <20110812171311.4d7bb640f38838bf7c34df50@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011 17:13:11 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> [The kernel.org mirroring is being very slow today]

  [s.l.o.w.]
 
> The net tree gained a build failure do I used the version from
> next-20110811.


On i386:

drivers/built-in.o: In function `be_rx_eqd_update':
be_main.c:(.text+0x569229): undefined reference to `__udivdi3'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
