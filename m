Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab1CYAWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 20:22:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57568
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab1CYAWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 20:22:10 -0400
Date: Thu, 24 Mar 2011 17:22:48 -0700 (PDT)
Message-Id: <20110324.172248.124014531.davem@davemloft.net>
To: alessandro.suardi@gmail.com
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: fix fib metrics
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=Xb3KCBKoVCcaVD5iyCtMCAnYaGF_DTeFQ0ays@mail.gmail.com>
References: <20110324.153623.45921344.davem@davemloft.net>
	<1301006652.2714.145.camel@edumazet-laptop>
	<AANLkTi=Xb3KCBKoVCcaVD5iyCtMCAnYaGF_DTeFQ0ays@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Suardi <alessandro.suardi@gmail.com>
Date: Fri, 25 Mar 2011 01:12:11 +0100

> If some change in the kernel broke my userspace, this usually
>  qualifies as a regression.

Not if userspace was working on an assumption it was not allowed to
make, which we believe it is in this case.
