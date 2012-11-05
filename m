Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2KESTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:19:54 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52684 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593Ab2KESTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:19:53 -0500
Date: Mon, 5 Nov 2012 10:19:52 -0800 (PST)
From: Andy King <acking@vmware.com>
To: David Miller <davem@davemloft.net>
Cc: pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        georgezhang@vmware.com
Message-ID: <783561822.12637564.1352139592543.JavaMail.root@vmware.com>
In-Reply-To: <20121105.130917.2098838777626057548.davem@davemloft.net>
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC22 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> The big and only question is whether anyone can actually use any of
> this stuff without your proprietary bits?

Do you mean the VMCI calls?  The VMCI driver is in the process of being
upstreamed into the drivers/misc tree.  Greg (cc'd on these patches) is
actively reviewing that code and we are addressing feedback.

Also, there was some interest from RedHat into using vSockets as a unified
interface, routed over a hypervisor-specific transport (virtio or
otherwise, although for now VMCI is the only one implemented).

Thanks!
- Andy
