Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab1EQGVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 02:21:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab1EQGVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 02:21:20 -0400
Date: Tue, 17 May 2011 09:21:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
Message-ID: <20110517062111.GD26989@redhat.com>
References: <1305574128.3456.23.camel@localhost.localdomain>
 <1305574518.2885.25.camel@bwh-desktop>
 <1305574680.3456.33.camel@localhost.localdomain>
 <1305575253.2885.28.camel@bwh-desktop>
 <20110516211459.GE18148@redhat.com>
 <1305588738.3456.65.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305588738.3456.65.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 04:32:18PM -0700, Shirley Ma wrote:
> Hello Michael,
> 
> Looks like to use a new flag requires more time/work.
> I am thinking
> whether we can just use HIGHDMA flag to enable zero-copy in macvtap to
> avoid the new flag for now since mavctap uses real NICs as lower device?
> 
> Thanks
> Shirley

Problem is, in your patch there are a set of restrictions on what the
device can do with the skb that we need to enforce somehow.
Also, how do we know it's a 'real NIC' and not a software device?

-- 
MST
