Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab0CQCRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:17:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43038
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab0CQCRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:17:50 -0400
Date: Tue, 16 Mar 2010 19:18:12 -0700 (PDT)
Message-Id: <20100316.191812.86986193.davem@davemloft.net>
To: xudong.hao@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: host panic based on kernel 2.6.34-RC1
From: David Miller <davem@davemloft.net>
In-Reply-To: <EB8593BCECAB3D40A8248BE0B6400A38464AED81@shzsmsx502.ccr.corp.intel.com>
References: <EB8593BCECAB3D40A8248BE0B6400A38464AED81@shzsmsx502.ccr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Hao, Xudong" <xudong.hao@intel.com>
Date: Wed, 17 Mar 2010 10:14:50 +0800

> I installed a latest kvm based on kernel 2.6.34-rc1, after I load kvm kvm_i=
> ntel module, and start /etc/init.d/kvm, a few minutes later, the system wil=
> l panic. The panic is easy to reproduce when I use tcpdump in host.
> However, if I stop /etc/init.d/kvm, everything is OK, host works fine. Does=
>  anyone met similar issue? any hint?

This is fixed in Linus's GIT tree already.


