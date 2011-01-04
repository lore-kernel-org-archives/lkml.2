Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab1ADKgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:36:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1ADKgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:36:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] rcu: remove SPARSE_RCU_POINTER
Date: Tue, 4 Jan 2011 11:36:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8; KDE/4.5.1; x86_64; ; )
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
References: <4D22DD95.7050308@cn.fujitsu.com>
In-Reply-To: <4D22DD95.7050308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101041136.02514.arnd@arndb.de>
X-Provags-ID: V02:K0:htjEZsMf7cwiWv4A2gPq+rhoDaNvdEw8NLGvX2t8jA8
 wcL9qEFy/6CaPfKSMXYz8z5TLqtl9n6XuLauz4QUVfjPiv83JC
 NETqk3z8srb1NjyuMsOr5W2xeu8OKGK1Tv3IwrfN91TtkcC3q6
 /bKe1xep+DsUooe7zdqfUg1nS+FeggW8y0ofIBas7e+HLdaSgu
 O06Ojm/Ls64BxImQq2n+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 January 2011 09:43:01 Lai Jiangshan wrote:
> As I known, __rcu annotations do not effect the result compiled kernel.
> 
> They work only when we use spare("make C=1" or "make C=2"),
> So we don't need another new switch for it since we have one
> for debugging(use spare or not).
> 
> signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

The intention of this option was to avoid introducing an excessive
number of false positives when using sparse.

We should only make that unconditional if we are reasonably convinced
that all the majority of warnings caused by it should actually
lead to changes in the code.

	Arnd
