Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945Ab0J2U2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:28:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43779
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757938Ab0J2U2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:28:12 -0400
Date: Fri, 29 Oct 2010 13:28:36 -0700 (PDT)
Message-Id: <20101029.132836.115944599.davem@davemloft.net>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Subject: Re: [PATCH v13 10/16] Add a hook to intercept external buffers
 from NIC driver.
From: David Miller <davem@davemloft.net>
In-Reply-To: <F2E9EB7348B8264F86B6AB8151CE2D7931E3CB834A@shsmsx502.ccr.corp.intel.com>
References: <33f51c5eddec843260451eccbfa3c5fdea13b479.1287132437.git.xiaohui.xin@intel.com>
	<20101019.082401.28817543.davem@davemloft.net>
	<F2E9EB7348B8264F86B6AB8151CE2D7931E3CB834A@shsmsx502.ccr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Date: Wed, 27 Oct 2010 09:33:12 +0800

> Somehow, it seems not a trivial work to support it now. Can we support it
> later and as a todo with our current work?

I would prefer the feature work properly, rather than only in specific
cases, before being integated.
