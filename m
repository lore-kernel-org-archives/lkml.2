Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2KHPr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:47:28 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:41722 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323Ab2KHPr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:47:26 -0500
Date: Thu, 8 Nov 2012 07:47:25 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: David Miller <davem@davemloft.net>, pv-drivers@vmware.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        georgezhang@vmware.com
Message-ID: <800083268.16640150.1352389645222.JavaMail.root@vmware.com>
In-Reply-To: <509A06AB.2020700@redhat.com>
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC23 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

>> Also, there was some interest from RedHat into using vSockets as
>> a unified interface, routed over a hypervisor-specific transport
>> (virtio or otherwise, although for now VMCI is the only one
>> implemented).
> 
> Can you outline how this can be done?  From a quick look over the
> code it seems like vsock has a hard dependency on vmci, is that
> correct?

That's correct, VMCI is wired into vSockets and we don't currently
provide any way to insert another transport.

> When making vsock a generic, reusable kernel service it should be
> the other way around:  vsock should provide the core implementation
> and an interface where hypervisor-specific transports (vmci,
> virtio, xenbus, ...) can register themself.

Sorry, that was a bad explanation on my part.  You're absolutely
correct as to how it _should_ work.  But it's up to Red Hat or others
to get the ball rolling and motivate the necessary work on vSockets
to make this happen.  As Greg says, "everyone is lazy and just wants
their code accepted" ;)

Thanks!
- Andy
