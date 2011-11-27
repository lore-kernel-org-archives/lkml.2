Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1K0Qsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 11:48:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab1K0Qsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 11:48:39 -0500
Date: Sun, 27 Nov 2011 18:50:14 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: levinsasha928@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-net: Acquire device lock when releasing device
Message-ID: <20111127165013.GB24941@redhat.com>
References: <1321607982-16283-1-git-send-email-levinsasha928@gmail.com>
 <20111126.154503.1317670837061338352.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111126.154503.1317670837061338352.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 03:45:03PM -0500, David Miller wrote:
> From: Sasha Levin <levinsasha928@gmail.com>
> Date: Fri, 18 Nov 2011 11:19:42 +0200
> 
> > Device lock should be held when releasing a device, and specifically
> > when calling vhost_dev_cleanup(). Otherwise, RCU complains about it:
>  ...
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Cc: virtualization@lists.linux-foundation.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> 
> Michael et al., are you guys going to gather this fix or should I
> apply it directly to thet net tree?
> 
> Thanks.

I think it needs a small tweak before being applied.

-- 
MST
