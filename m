Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0HBXua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:50:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36650 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0HBXu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:50:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 3 Aug 2010 08:45:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/7][memcg] cgroup arbitarary ID allocation
Message-Id: <20100803084535.ea5cafc4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100802180429.GY3863@balbir.in.ibm.com>
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100727165417.dacbe199.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802180429.GY3863@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 23:34:29 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-07-27 16:54:17]:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > When a subsystem want to make use of "id" more, it's necessary to
> > manage the id at cgroup subsystem creation time. But, now,
> > because of the order of cgroup creation callback, subsystem can't
> > declare the id it wants. This patch allows subsystem to use customized
> > ID for themselves.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> 
> What happens if the id is taken already? Could you please explain how
> this is used?
> 

This patch is dropped.

-Kame

