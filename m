Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734Ab1LPIHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:07:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59374 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1LPIHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:07:35 -0500
Message-ID: <1324022848.4496.27.camel@lappy>
Subject: Re: [PATCH 0/2] vhot-net: Use kvm_memslots instead of vhost_memory
 to translate GPA to HVA
From: Sasha Levin <levinsasha928@gmail.com>
To: Zang Hongyong <zanghongyong@huawei.com>
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xiaowei.yang@huawei.com, hanweidong@huawei.com, wusongwei@huawei.com
Date: Fri, 16 Dec 2011 10:07:28 +0200
In-Reply-To: <1324022358.4496.25.camel@lappy>
References: <1324013528-3663-1-git-send-email-zanghongyong@huawei.com>
	 <1324019151.4496.9.camel@lappy> <4EEAF5D1.2080805@huawei.com>
	 <1324022358.4496.25.camel@lappy>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 09:59 +0200, Sasha Levin wrote:
> There has been a great deal of effort to keep vhost and kvm untangled.
> One example is the memory translation it has to do, another one is the
> eventfd/irqfd thing it does just so it could signal an IRQ in the guest
> instead of accessing the guest directly.

Actually, CONFIG_VHOST_NET doesn't even depend on CONFIG_KVM, so your
patch will break build when (CONFIG_VHOST_NET=y && CONFIG_KVM=n).

-- 

Sasha.

