Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab0GWAEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 20:04:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48460 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab0GWAEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 20:04:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 23 Jul 2010 08:59:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Nauman Rafique <nauman@google.com>,
        Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, linux-kernel@vger.kernel.org,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-Id: <20100723085944.9fb9cb8b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTin9TCziHU-AX42aVWpaFDX5=4NwojGxFSFnRFAq@mail.gmail.com>
References: <4C369009.80503@ds.jp.nec.com>
	<20100709134546.GC3672@redhat.com>
	<4C37BC1A.20102@ds.jp.nec.com>
	<AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com>
	<20100710132417.GA2752@redhat.com>
	<20100712092004.3b27e13e.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTin9TCziHU-AX42aVWpaFDX5=4NwojGxFSFnRFAq@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 12:28:50 -0700
Greg Thelen <gthelen@google.com> wrote:

> > I've just waited for dirty-ratio patches because I know someone is working on.
> > But, hmm, I'll consider to start work by myself.
> 
> I have some patches that I have to address the dirty-ratios.  I will post them.
> 

please wait until my proposal to implement a light-weight lock-less update_stat()
I'll handle FILE_MAPPED in it and add a generic interface for updating statistics
in mem_cgroup via page_cgroup.
(I'll post it today if I can, IOW, I'm lucky.)

If not, we have to discuss the same thing again in a hell.

Thanks,
-Kame

