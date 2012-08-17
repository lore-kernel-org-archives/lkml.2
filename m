Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030910Ab2HQJnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:43:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35427 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab2HQJn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:43:29 -0400
Message-ID: <1345196594.29668.58.camel@twins>
Subject: Re: [PATCH] sched: remove useless code in yield_to
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Date: Fri, 17 Aug 2012 11:43:14 +0200
In-Reply-To: <502DEB32.8000106@linux.vnet.ibm.com>
References: <4F13EFBE.1030002@linux.vnet.ibm.com>
	 <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com>
	 <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com>
	 <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop>
	 <20120126100429.GA3853@elte.hu> <4F21FC69.6040402@linux.vnet.ibm.com>
	 <4F222B2B.6010602@gmail.com> <4F24E804.5090808@linux.vnet.ibm.com>
	 <20120129163328.GC23408@elte.hu> <4F260BFE.2070503@linux.vnet.ibm.com>
	 <4F260DAE.4000008@gmail.com> <4F262ED9.7040003@linux.vnet.ibm.com>
	 <4FF2925A.9060005@linux.vnet.ibm.com> <1342102029.28010.3.camel@twins>
	 <502DEB32.8000106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 14:56 +0800, Michael Wang wrote:
> 
> I think Mike also agreed to remove that piece of code, should we
> action now?

Right you are, applied.
