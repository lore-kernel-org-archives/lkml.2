Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1ELJFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:05:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab1ELJFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:05:19 -0400
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
From: Peter Zijlstra <peterz@infradead.org>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
In-Reply-To: <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
	 <20110502061411.GA16682@elte.hu>
	 <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
	 <20110504111355.GC5914@elte.hu>
	 <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 11:08:20 +0200
Message-ID: <1305191300.2914.263.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 18:29 -0700, Nikhil Rao wrote:
> > It's a cost/benefit analysis and for 32-bit systems the benefits seem to be
> > rather small, right?
> >
> 
> Yes, that's right. The benefits for 32-bit systems do seem to be limited.

deep(er) hierarchies on 32 bits still require this, it would be good to
verify that the cgroup mess created by the insanity called libvirt will
indeed work as expected.



