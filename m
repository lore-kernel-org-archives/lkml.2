Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0GCF30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 01:29:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57362
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab0GCF3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 01:29:24 -0400
Date: Fri, 02 Jul 2010 22:29:38 -0700 (PDT)
Message-Id: <20100702.222938.115942060.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, krkumar2@in.ibm.com
Subject: Re: [GIT PULL net-2.6] vhost-net: more error handling fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100701164127.GA3199@redhat.com>
References: <20100701164127.GA3199@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 1 Jul 2010 19:41:27 +0300

> David,
> The following tree includes more fixes dealing with
> error handling in vhost-net. It is on top of net-2.6.
> Please merge it for 2.6.35.
> Thanks!
> 
> The following changes since commit 38000a94a902e94ca8b5498f7871c6316de8957a:
> 
>   sky2: enable rx/tx in sky2_phy_reinit() (2010-06-23 14:37:04 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net
> 
> Michael S. Tsirkin (2):
>       vhost: break out of polling loop on error
>       vhost: add unlikely annotations to error path

Pulled.
