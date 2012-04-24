Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2DXI4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:56:40 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:26907 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab2DXI4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:56:38 -0400
Date: Tue, 24 Apr 2012 10:55:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, swarren@wwwdotorg.org,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/2] i2c: tegra: support for I2C_M_NOSTART protocol
 mangling
Message-ID: <20120424105557.7ac07232@endymion.delvare>
In-Reply-To: <1335251976-31925-3-git-send-email-ldewangan@nvidia.com>
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>
	<1335251976-31925-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012 12:49:36 +0530, Laxman Dewangan wrote:
> Adding support for protocol mangling I2C_M_NOSTART.
> When multiple message transfer request made through i2c
> and if any message is flagged with I2C_M_NOSTART then
> it will not send the start/repeat start/address of that
> message i.e. send the data directly.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/i2c/busses/i2c-tegra.c |   32 +++++++++++++++++++++++++++-----
>  1 files changed, 27 insertions(+), 5 deletions(-)

What do you need this for?

-- 
Jean Delvare
