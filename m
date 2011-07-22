Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1GVGhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:37:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33315 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab1GVGhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:37:09 -0400
Date: Thu, 21 Jul 2011 23:37:03 -0700 (PDT)
Message-Id: <20110721.233703.1255795125689533592.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mashirle@us.ibm.com, xma@us.ibm.com
Subject: Re: [PULL net (try 2)] vhost-net: zercopy mode fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110722063238.GB9637@redhat.com>
References: <20110722060046.GA8876@redhat.com>
	<20110722063238.GB9637@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 21 Jul 2011 23:37:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Fri, 22 Jul 2011 09:32:38 +0300

> Fixing a corrupted pull request sent earlier.
> Sorry about the noise!
> 
> The following includes vhost-net fixes - both in the
> experimental zero copy mode.
> Please pull for 3.1.

Pulled, thanks!
