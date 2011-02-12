Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1BLLP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 06:15:29 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:18877 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab1BLLPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 06:15:25 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAj7VU1tgner/2dsb2JhbACEHqFgdKogkDSBJ4NBdgSPSw
Date: Sat, 12 Feb 2011 12:15:04 +0100
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH -next/mmotm] net/can: fix softing build errors
Message-ID: <20110212111344.GA328@e-circ.dyndns.org>
References: <201102110100.p1B10sDx029244@imap1.linux-foundation.org>
 <20110211223312.be571303.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110211223312.be571303.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:33:12PM -0800, Randy Dunlap wrote:
> 
> warning: (CAN_SOFTING_CS) selects CAN_SOFTING which has unmet direct dependencies (NET && CAN && CAN_DEV && HAS_IOMEM)
> 
> with this partial config:
> 
> CONFIG_CAN=m
> # CONFIG_CAN_RAW is not set
> # CONFIG_CAN_BCM is not set
> # CAN Device Drivers
> # CONFIG_CAN_VCAN is not set
> CONFIG_CAN_SLCAN=m
> # CONFIG_CAN_DEV is not set
> CONFIG_CAN_SOFTING=m
> CONFIG_CAN_SOFTING_CS=m
> # CONFIG_CAN_DEBUG_DEVICES is not set
I understand the output, but I don't understand the cause well enough.
CAN_SOFTING=m has a 'depends on CAN_DEV'
Is it then possible to have CAN_SOFTING=m _and not_ CAN_DEV ?
> 

regards,
Kurt
