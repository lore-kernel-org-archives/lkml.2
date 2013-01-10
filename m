Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab3AJCnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:43:01 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:50593 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230Ab3AJCnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:43:00 -0500
Date: Wed, 9 Jan 2013 18:42:57 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: pv-drivers@vmware.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, Dmitry Torokhov <dtor@vmware.com>
Message-ID: <1426158581.24554896.1357785777229.JavaMail.root@vmware.com>
In-Reply-To: <50ED25E7.9010609@redhat.com>
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [108.68.97.87]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC23 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Our position is that VSOCK feature set is more complete and that it
> > should be possible to use transports other than VMCI for VSOCK
> > traffic, should interested parties implement them,
> 
> Implementing other transports requires restructing vsock (and vmci)
> first as the current vsock code is not a hypervisor neutral service.

I'm going to bite the bullet and spend the next couple of days doing
just that: factoring out the VMCI bits and hiding them behind a
transport layer.  It'll be a bit rough, but it'll be a start.  We'll
submit another patch series next week with that.  I'm hoping that'll
get us over this hump, since it should by hypervisor agnostic at
that point.  It'll be up to you guys to add virtio, though :)

And in the meantime, are there any other glaring errors that we need
to address?

Thanks!
- Andy
