Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2KYNH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 08:07:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:60135 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab2KYNHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 08:07:55 -0500
Subject: Re: [PATCH 1/2] [for 3.4] drivers/virt: the Freescale hypervisor driver doesn't need to check MSR[GS]
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1337281828-31120-1-git-send-email-timur@freescale.com>
Date: Sun, 25 Nov 2012 07:07:31 -0600
Cc: <linuxppc-dev@linux.freescale.net>, Scott Wood <scottwood@freescale.com>,
        Anatolij Gustschin <agust@denx.de>, <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <AB770BBF-9E2B-461F-B0A9-F141517EBEDD@kernel.crashing.org>
References: <1337281828-31120-1-git-send-email-timur@freescale.com>
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17, 2012, at 2:10 PM, Timur Tabi wrote:

> The MSR[GS] bit indicates whether the kernel is running in processor guest
> state mode, but such a check is unnecessary.  The driver already checks
> for the /hypervisor node and the fsl,hv-version property, so it already
> knows that it's running under the Freescale hypervisor.
> 
> There is nothing in the driver that inherently requires guest state,
> anyway.
> 
> This fixes a break that can occur in some randconfig builds.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
> drivers/virt/fsl_hypervisor.c |    3 ---
> 1 files changed, 0 insertions(+), 3 deletions(-)

applied to next

- k
