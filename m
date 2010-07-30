Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab0G3Ks5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:48:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49821 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab0G3Ksz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:48:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Jul 2010 19:43:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100730194359.e6761b78.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTimvZSFHCZZ=SCQF8DtZ3vVYJmA=4qWs2SDAgvKi@mail.gmail.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTing_3HoC9oWNheHJPgQWp2xmN6-C_cyZxoJUqc_@mail.gmail.com>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTimvZSFHCZZ=SCQF8DtZ3vVYJmA=4qWs2SDAgvKi@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 21:46:10 -0700
Hugh Dickins <hughd@google.com> wrote:

> On Thu, Jul 29, 2010 at 9:14 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > I'll prepare a routine not-quick-fix.
> 
> Thank you!
> 

plz wait until the next week..I found I can't post today ;(

Maybe trying my quick hack patch (posted) will be enough small for
backporting etc.

Thanks,
-Kame

