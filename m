Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2C0W5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:57:35 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:50267 "EHLO violet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756724Ab2C0W5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:57:34 -0400
Date: Wed, 28 Mar 2012 00:54:53 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] r8169: support RTL8411
Message-ID: <20120327225453.GD22177@electric-eye.fr.zoreil.com>
References: <1332834834-5185-1-git-send-email-hayeswang@realtek.com> <1332834834-5185-5-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332834834-5185-5-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
[...]
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 6c2835f..99daad7 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
[...]
> @@ -250,6 +252,9 @@ static const struct {
>  							JUMBO_9K, false),
>  	[RTL_GIGA_MAC_VER_37] =
>  		_R("RTL8402",		RTL_TD_1, FIRMWARE_8402_1,
> +							JUMBO_1K, true),
> +	[RTL_GIGA_MAC_VER_38] =
> +		_R("RTL8411",		RTL_TD_1, FIRMWARE_8411_1,
>  							JUMBO_1K, true)

Realtek's product page documents this chipset as a gigabit one. It seems
strange to configure it as a jumbo packet unable one.

The patch seems otherwise fine.

On a tangent topic:

"The RTL8411 supports Receive Side Scaling (RSS) to hash incoming TCP
connections and load-balance received data processing across multiple CPUs.
RSS improves the number of transactions per second and number of connections
per second, for increased network throughput. Header Data Split (HDS) support
enables faster processing of TCP/IP networking protocols for improved network
performance.

Virtual Machine Queue (VMQ) is a hardware virtualization technology for the
efficient transfer of network traffic to a virtualized host OS. VMQ uses
hardware packets filtering to deliver packet data from an external virtual
machine network directly to virtual machines, which reduces the overhead of
routing packets and copying them from the management operating system to the
virtual machine.

Note: RTL8411 Virtual Machine Queue (VMQ) is only functional in computers
running Windows Server 2008 R2 with the Hyper-V server role installed."

Will Realtek consider helping make those being available on Linux ?

-- 
Ueimor
