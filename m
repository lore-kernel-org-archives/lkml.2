Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2FTIUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:20:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35374 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2FTIUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:20:38 -0400
Date: Wed, 20 Jun 2012 01:20:37 -0700 (PDT)
Message-Id: <20120620.012037.783895812206310043.davem@davemloft.net>
To: viresh.kumar2@arm.com
Cc: bhupesh.sharma@st.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        federico.vaga@gmail.com, giancarlo.asnaghi@st.com, wg@grandegger.com,
        mkl@pengutronix.de, spear-devel@list.st.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FE18502.6040409@arm.com>
References: <20120620133348.a9ff31a72ffd11818f574fe3@canb.auug.org.au>
	<D5ECB3C7A6F99444980976A8C6D896384FAA275CA8@EAPEX1MAIL1.st.com>
	<4FE18502.6040409@arm.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: viresh kumar <viresh.kumar2@arm.com>
Date: Wed, 20 Jun 2012 09:08:34 +0100

> Please see following patchset from me, that got applied in linux-next
> 
> https://lkml.org/lkml/2012/4/24/154
> 
> Please check if this patchset is present in your build repo. I believe it should be
> there. If it is, then you shouldn't get these errors.

Well, then Stephen shouldn't get those errors either.

But obviously he did.

But all of this talk about changes existing only in linux-next is
entirely moot.  Because The damn thing MUST build independently inside
of net-next which doesn't have those clock layer changes.

Someone send me a clean fix for net-next now.
