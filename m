Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab1KOTcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:32:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60980 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756257Ab1KOTcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:32:05 -0500
Message-ID: <1321385523.21286.12.camel@Joe-Laptop>
Subject: Re: [PATCH net-next v4 2/8] forcedeth: Add messages to indicate
 using MSI or MSI-X
From: Joe Perches <joe@perches.com>
To: David Decotigny <david.decotigny@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Szymon Janc <szymon@janc.net.pl>,
        Richard Jones <rick.jones2@hp.com>, Ayaz Abdulla <AAbdulla@nvidia.com>,
        Mike Ditto <mditto@google.com>
Date: Tue, 15 Nov 2011 11:32:03 -0800
In-Reply-To: <97a5a50baaca7b272dfb7a1a06e88df4888f12b9.1321384662.git.david.decotigny@google.com>
References: <cover.1321384662.git.david.decotigny@google.com>
	 <97a5a50baaca7b272dfb7a1a06e88df4888f12b9.1321384662.git.david.decotigny@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 11:25 -0800, David Decotigny wrote:
> From: Mike Ditto <mditto@google.com>
> 
> This adds a few debug messages to indicate whether PCIe interrupts are
> signaled with MSI or MSI-X.

Perhaps the changelog would be better without "debug".
These added messages aren't really debug messages.
They are emitted as netdev_info vs netdev_dbg.

> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
[]
> @@ -3810,6 +3810,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
> +			netdev_info(dev, "MSI-X enabled\n");
> @@ -3831,6 +3832,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
> +			netdev_info(dev, "MSI enabled\n");


