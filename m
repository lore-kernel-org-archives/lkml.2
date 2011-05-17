Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab1EQUyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:54:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56334 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab1EQUyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:54:03 -0400
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110517062111.GD26989@redhat.com>
References: <1305574128.3456.23.camel@localhost.localdomain>
	 <1305574518.2885.25.camel@bwh-desktop>
	 <1305574680.3456.33.camel@localhost.localdomain>
	 <1305575253.2885.28.camel@bwh-desktop> <20110516211459.GE18148@redhat.com>
	 <1305588738.3456.65.camel@localhost.localdomain>
	 <20110517062111.GD26989@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 13:53:19 -0700
Message-ID: <1305665599.10756.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 09:21 +0300, Michael S. Tsirkin wrote:
> Problem is, in your patch there are a set of restrictions on what the
> device can do with the skb that we need to enforce somehow.
> Also, how do we know it's a 'real NIC' and not a software device?

I checked macvtap newlink, it doesn't seem to block software device.

So we need to work on the wider feature bit first.

Shirley

