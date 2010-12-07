Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0LGEDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 23:03:11 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56727 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0LGEDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 23:03:09 -0500
Content-Type: text/plain; charset=UTF-8
Subject: PowerPC, ftrace: Add PPC raw syscall tracepoints & ftrace fixes
From: Ian Munsie <imunsie@au1.ibm.com>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <1290041086-sup-5766@au1.ibm.com> <20101118151141.GA3368@redhat.com> <1290133618-sup-2278@au1.ibm.com> <4CECACF9.3080907@linux.vnet.ibm.com> <4CFD7182.4060206@linux.vnet.ibm.com>
Date: Tue, 07 Dec 2010 15:03:06 +1100
Message-Id: <1291693287-sup-5971@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Avantika Mathur's message of Tue Dec 07 10:28:02 +1100 2010:
> Were you able to find any time to work on the patches?  I understand if 
> you are not able to work on this.  If you don't have time to push the 
> patches soon,  I would like to push at your 4 patches that add the 
> powerpc syscall tracing support.
> Let me know what your status is.  I woud like to plan to do this in the 
> next couple days

Hi Avantika,

I haven't had a chance to work on them unfortunately, I've been pretty
tied up with other work.

I've rebased the subset of patches necessary to get the raw syscall
tracepoints working and to ensure that none of the unworking ftrace
syscall events show up. This won't give you the per syscall events that
ftrace can provide, but if all you need is the raw tracepoints they will
work. I'll send them to the mailing list shortly.


Jason: It seems that publishing a tree for you to work on will be time
consuming due to legal concerns of publishing the whole kernel tree.
Rather than go down that path it will be easier for me to just send you
the patches directly. I'll try to find some time to rebase them and send
them to you before I go away next week.


Cheers,
-Ian
