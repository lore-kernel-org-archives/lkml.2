Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab0HCXmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 19:42:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41199 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab0HCXmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 19:42:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Aug 2010 08:36:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>, nigel@tuxonice.net
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100804083652.92b5b2df.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTim5STgpNEdh3JSU_BG5X8Wxh-gbXDmWYLdufNb3@mail.gmail.com>
References: <201007282320.39528.linux@rainbow-software.org>
	<201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTim5STgpNEdh3JSU_BG5X8Wxh-gbXDmWYLdufNb3@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 12:50:43 +0200
Andrea Gelmini <andrea.gelmini@gmail.com> wrote:

> 2010/7/29 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> > Considering possible cases...and here is a patch.
> > but I'm not fully sure. Could you clarify ?
> 
> I'm using this patch (with the one for ksm.c by Arcangeli) since the publishing.
> It seems all works pretty well, with TuxOnIce also.
> 
> Never had the need to reboot the system.
> 

Good, thank you for reporting !
I'd like to add your Tested-by:

Thanks,
-Kame

> Thanks a lot,
> Andrea
> 

