Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382Ab1ESPMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:12:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932931Ab1ESPMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:12:37 -0400
Date: Thu, 19 May 2011 08:12:13 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Neil Horman <nhorman@redhat.com>, Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [Patch] bridge: call NETDEV_ENSLAVE notifiers when adding a
 slave
Message-ID: <20110519081213.15c05da2@nehalam>
In-Reply-To: <1305800661-4081-1-git-send-email-amwang@redhat.com>
References: <1305794393-20775-1-git-send-email-amwang@redhat.com>
	<1305800661-4081-1-git-send-email-amwang@redhat.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 18:24:17 +0800
Amerigo Wang <amwang@redhat.com> wrote:

> In the previous patch I added NETDEV_ENSLAVE, now
> we can notify netconsole when adding a device to a bridge too.
> 
> By the way, s/netdev_bonding_change/call_netdevice_notifiers/ in
> bond_main.c, since this is not bonding specific.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Neil Horman <nhorman@redhat.com>
> 

Is there a usage for this? What listens for this notification?
