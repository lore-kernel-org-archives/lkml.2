Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1IPIj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:39:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:8950 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab1IPIj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:39:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,392,1312182000"; 
   d="scan'208";a="17757508"
Date: Fri, 16 Sep 2011 16:36:24 -0400
From: xingchao <xingchao.wang@intel.com>
To: Paul Turner <pjt@google.com>
CC: Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH] cfs: remove unused 'if' condition checking
Message-ID: <20110916163624.15a96dd9@wang-bj-intel>
In-Reply-To: <CAPM31RKJo1x04bms2hZvpNX5S45hnz8RmFw80nKqDecLwDWuAw@mail.gmail.com>
References: <1316194552-12019-1-git-send-email-xingchao.wang@intel.com>
	<4E72FD93.2060805@google.com>
	<20110916081700.GC10741@zhy>
	<CAPM31RKJo1x04bms2hZvpNX5S45hnz8RmFw80nKqDecLwDWuAw@mail.gmail.com>
Organization: INTEL
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011 16:28:25 +0800
Paul Turner <pjt@google.com> wrote:

> >
> > But it looks ok on my side.
> > And on LKML: https://lkml.org/lkml/2011/9/16/11
> >
> 
> Yeah looks like my client mangled it -- no idea H-T-F it accomplished
> that,
> 
> Sorry,
> 
> - Paul
> 
> > So maybe it's not Xingchao's problem.
> >
> > Thanks,
> > Yong
> >
> >>

Thanks Paul, Yong, i will send the V2 patch later.

--xingchao
