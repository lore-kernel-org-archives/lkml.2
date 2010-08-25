Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0HYAWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:22:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51125 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0HYAWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:22:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Aug 2010 09:17:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
Message-Id: <20100825091747.f6ea9e0e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTi=HwPeWafzTBh66g37XxZouKicsemmnTE-Cvz=Y@mail.gmail.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<4C738B34.6070602@cn.fujitsu.com>
	<AANLkTi=HwPeWafzTBh66g37XxZouKicsemmnTE-Cvz=Y@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 17:11:22 -0700
Paul Menage <menage@google.com> wrote:

> On Tue, Aug 24, 2010 at 2:04 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >
> > Maybe pass the id number to id_attached() is better.
> >
> > And actually the @ss argument is not necessary, because the memcg's
> > id_attached() handler of course knows it's dealing with the memory
> > cgroup subsystem.
> >
> > So I suspect we can just remove all the @ss from all the callbacks..
> 
> Yes, I don't think any subsystem uses these. They dated originally
> from when, as part of the initial cgroups framwork, I included a
> library that could wrap a mostly-unmodified CKRM resource controller
> into a cgroups subsystem, at which point the callback code didn't
> necessarily know which subsystem it was being called for. But that's
> obsolete now.
> 

Hmm, then, should I remove it in the next version, or leave it as it is
now and should be removed by another total clean up ?

(IOW, mixture of inconsistent interface is O.K. ?)

Thanks,
-Kame

