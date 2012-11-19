Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab2KSJ7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:59:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:51594 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab2KSJ7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:59:45 -0500
Message-ID: <1353319158.23412.88.camel@pasglop>
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Andy King <acking@vmware.com>,
        pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        David Miller <davem@davemloft.net>, georgezhang@vmware.com
Date: Mon, 19 Nov 2012 20:59:18 +1100
In-Reply-To: <50A55F57.7080804@us.ibm.com>
References: <783561822.12637564.1352139592543.JavaMail.root@vmware.com>
	 <509A06AB.2020700@redhat.com> <50A55F57.7080804@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 15:32 -0600, Anthony Liguori wrote:
> 
> The concept was Nacked and that led to the abomination of virtio-serial.  If an 
> address family for virtualization is on the table, we should reconsider 
> AF_VMCHANNEL.
> 
> I'd be thrilled to get rid of virtio-serial...

Ack.

Ben.


