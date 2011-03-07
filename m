Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab1CGGaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 01:30:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab1CGGa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 01:30:28 -0500
Date: Mon, 7 Mar 2011 08:30:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: copy_from_user -> __copy_from_user
Message-ID: <20110307063014.GA11330@redhat.com>
References: <20110306113349.GA24333@redhat.com>
 <20110306.180339.193718218.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110306.180339.193718218.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 06:03:39PM -0800, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 6 Mar 2011 13:33:49 +0200
> 
> > copy_from_user is pretty high on perf top profile,
> > replacing it with __copy_from_user helps.
> > It's also safe because we do access_ok checks during setup.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Is Rusty going to take this or should I?

Sorry about not making this clear.  I'll give it a day or two for review
then put it on the vhost tree myself.
Thanks!
