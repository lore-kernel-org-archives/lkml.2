Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab1AEDRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:17:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40987 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1AEDRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:17:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <1294161399.2016.175.camel@laptop>
References: <20110104151345.3BC2.A69D9226@jp.fujitsu.com> <1294161399.2016.175.camel@laptop>
Message-Id: <20110105120219.B639.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  5 Jan 2011 12:17:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NAK NAK NAK, yield_to is utter crap, and the only reason kvm 'needs' it
> is because its wants to be utter crap (run unmodified guests).
> 
> There is plenty of sane serialization primitives for userspace, fix your
> locking mess instead of pushing crap.
> 
> The only reason I'm maybe half-way considering this is because its a
> pure in-kernel interface which we can 'fix' once unmodified guests
> aren't important anymore.

KVM also have slow and inefficient mecanism. Userspace have a lot of
slow primitives too.

But okey, I'm withdraw this claim even though I disagree userspace have
plenty of sane serialization. It's offtopic and we need more discuss
at proper place.

Thanks.



