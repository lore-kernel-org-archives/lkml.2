Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab0JKP1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:27:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33138
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980Ab0JKP1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:27:06 -0400
Date: Mon, 11 Oct 2010 08:27:28 -0700 (PDT)
Message-Id: <20101011.082728.193709462.davem@davemloft.net>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Subject: Re: [PATCH v12 06/17] Use callback to deal with skb_release_data()
 specially.
From: David Miller <davem@davemloft.net>
In-Reply-To: <F2E9EB7348B8264F86B6AB8151CE2D793064B2A9D8@shsmsx502.ccr.corp.intel.com>
References: <f2bf65a8a7676bbd3e8a749ae93d99e88671d35d.1285853725.git.xiaohui.xin@intel.com>
	<20101001.001439.85411154.davem@davemloft.net>
	<F2E9EB7348B8264F86B6AB8151CE2D793064B2A9D8@shsmsx502.ccr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Date: Mon, 11 Oct 2010 15:06:05 +0800

> That's to avoid the new cache miss caused by using destructor_arg in data path
> like skb_release_data().
> That's based on the comment from Eric Dumazet on v7 patches.

Thanks for the explanation.
