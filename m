Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab0ECWYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758575Ab0ECWYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:24:12 -0400
Date: Tue, 4 May 2010 01:20:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] first round of vhost-net enhancements for net-next
Message-ID: <20100503222022.GC16181@redhat.com>
References: <20100503213244.GA16006@redhat.com> <20100503.150729.00474027.davem@davemloft.net> <20100503.150829.254849182.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100503.150829.254849182.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 03:08:29PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 03 May 2010 15:07:29 -0700 (PDT)
> 
> > From: "Michael S. Tsirkin" <mst@redhat.com>
> > Date: Tue, 4 May 2010 00:32:45 +0300
> > 
> >> The following tree includes a couple of enhancements that help vhost-net.
> >> Please pull them for net-next. Another set of patches is under
> >> debugging/testing and I hope to get them ready in time for 2.6.35,
> >> so there may be another pull request later.
> > 
> > Pulled, thanks.
> 
> Nevermind, reverted.
> 
> Do you even compile test what you send to people?
> 
> drivers/net/macvtap.c: In function ‘macvtap_ioctl’:
> drivers/net/macvtap.c:713: warning: control reaches end of non-void function
> 
> You're really batting 1000 today Michael...

Ouch. Should teach me not to send out stuff after midnight. Sorry about
the noise.

-- 
MST
