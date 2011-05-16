Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1EPVa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:30:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43625 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1EPVa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:30:57 -0400
Subject: Re: [PATCH V5 4/6 net-next] vhost: vhost TX zero-copy support
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110516212401.GF18148@redhat.com>
References: <1305574484.3456.30.camel@localhost.localdomain>
	 <20110516204540.GD18148@redhat.com>
	 <1305579414.3456.49.camel@localhost.localdomain>
	 <20110516212401.GF18148@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 14:30:49 -0700
Message-ID: <1305581449.3456.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 00:24 +0300, Michael S. Tsirkin wrote:
> Very strange, it sounds like a bug, but I can't tell where: in
> host or in guest. If it's in the guest, we must fix it.
> If in host, we should only fix it if it makes life simpler for us.
> Could you try to nail it down pls?  Another question: will code get
> simpler or more complex if that restriction's removed? 

It should be similar. We still need to maintain the pending list, and
mark the DMA done ids.

I can make a try to narrow this issue down.

Thanks
Shirley

