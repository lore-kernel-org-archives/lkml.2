Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1GGLtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:49:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40549 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab1GGLtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:49:13 -0400
Date: Thu, 07 Jul 2011 04:49:10 -0700 (PDT)
Message-Id: <20110707.044910.156889850897136407.davem@davemloft.net>
To: mst@redhat.com
Cc: mashirle@us.ibm.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V8 0/4 net-next] macvtap/vhost TX zero-copy support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110707113715.GA32632@redhat.com>
References: <1309990525.10209.12.camel@localhost.localdomain>
	<20110707.040840.809661052978541081.davem@davemloft.net>
	<20110707113715.GA32632@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 07 Jul 2011 04:49:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 7 Jul 2011 14:37:15 +0300

> Apply patches 1-3 for now?

Done, and I fixed the use-after-free in patch #2.

