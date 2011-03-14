Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1CNHkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 03:40:01 -0400
Received: from smtp.nokia.com ([147.243.1.47]:58720 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab1CNHkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 03:40:00 -0400
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" 
	<remi.denis-courmont@nokia.com>
Organization: MeeGo Devices - Nokia
To: ext Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/2] NET: cdc-phonet, fix stop-queue handling
Date: Mon, 14 Mar 2011 09:39:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-27-generic; KDE/4.5.1; i686; ; )
Cc: davem@davemloft.net, jirislaby@gmail.com, netdev@vger.kernel.org,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1300035271-8138-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1300035271-8138-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103140939.57056.remi.denis-courmont@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 March 2011 18:54:30 ext Jiri Slaby, you wrote:
> Currently there is a warning emitted by the cdc-phonet driver:
> WARNING: at include/linux/netdevice.h:1557 usbpn_probe+0x3bb/0x3f0
> [cdc_phonet]() Modules linked in: ...
> Pid: 5877, comm: insmod Not tainted 2.6.37.3-16-desktop #1
> Call Trace:
>  [<ffffffff810059b9>] dump_trace+0x79/0x340
>  [<ffffffff81520fdc>] dump_stack+0x69/0x6f
>  [<ffffffff810580eb>] warn_slowpath_common+0x7b/0xc0
>  [<ffffffffa00254fb>] usbpn_probe+0x3bb/0x3f0 [cdc_phonet]
> ...
> ---[ end trace f5d3e02908603ab4 ]---
> netif_stop_queue() cannot be called before register_netdev()
> 
> So remove netif_stop_queue from the probe funtction to avoid that.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
> Cc: David S. Miller <davem@davemloft.net>

Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>

-- 
Rémi Denis-Courmont
http://www.remlab.net/
