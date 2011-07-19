Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1GSX3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:29:01 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:37000 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751351Ab1GSX3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:29:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cTeKAuP9MpFqIE01Kvw1/glZBuKQzX5ow7NYMOh08971qMp0W1jSkSCfKIYNNVOEWb2hx44MviugRATLKvndrS/oBCsmhOUqZDKw05d7yxQMwVSnxM7FCMtZL9dddV9Z;
Date: Tue, 19 Jul 2011 16:28:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Hugh Dickins <hughd@google.com>
Cc: akpm <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
Message-Id: <20110719162857.63b6b0be.rdunlap@xenotime.net>
In-Reply-To: <alpine.LSU.2.00.1107191532130.1541@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
	<alpine.LSU.2.00.1106140341070.29206@sister.anvils>
	<20110617163854.49225203.akpm@linux-foundation.org>
	<20110617170742.282a1bd6.rdunlap@xenotime.net>
	<20110617171228.4c85fd38.rdunlap@xenotime.net>
	<alpine.LSU.2.00.1106171845480.20321@sister.anvils>
	<alpine.LSU.2.00.1107191532130.1541@sister.anvils>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011 15:36:37 -0700 (PDT) Hugh Dickins wrote:

> On Fri, 17 Jun 2011, Hugh Dickins wrote:
> > On Fri, 17 Jun 2011, Randy Dunlap wrote:
> > 
> > > > And one Andrew Morton has a userspace radix tree test harness at
> > > > http://userweb.kernel.org/~akpm/stuff/rtth.tar.gz
> > 
> > This should still be as relevant as it was before, but I notice its
> > radix_tree.c is almost identical to the source currently in the kernel
> > tree, so I ought at the least to keep it in synch.
> 
> I was hoping to have dealt with this by now, Randy; but after downloading
> an up-to-date urcu, I'm finding what's currently in rtth does not build
> with it.  Unlikely to be hard to fix, but means I'll have to defer it a
> little while longer.

Sure, not a problem.  Thanks for not dropping it completely.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
