Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0FKFNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:13:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56390 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab0FKFNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:13:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Jun 2010 14:08:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page
 cache control
Message-Id: <20100611140842.e748d47d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100611140553.956f31ab.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	<20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
	<4C10B3AF.7020908@redhat.com>
	<20100610142512.GB5191@balbir.in.ibm.com>
	<1276214852.6437.1427.camel@nimitz>
	<20100611105441.ee657515.kamezawa.hiroyu@jp.fujitsu.com>
	<20100611044632.GD5191@balbir.in.ibm.com>
	<20100611140553.956f31ab.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 14:05:53 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> I can think of both way in kernel and in user approarh and they should be
> complement to each other.
> 
> An example of kernel-based approach is.
>  1. add a shrinker callback(A) for balloon-driver-for-guest as guest kswapd.
>  2. add a shrinker callback(B) for balloon-driver-for-host as host kswapd.
> (I guess current balloon driver is only for host. Please imagine.)
                                              ^^^^
                                              guest.
Sorry.
-Kame

