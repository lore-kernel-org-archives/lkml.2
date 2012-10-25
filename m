Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992716Ab2JYUla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:41:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34206 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992675Ab2JYUl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:41:28 -0400
Message-ID: <5089A3F5.40005@wwwdotorg.org>
Date: Thu, 25 Oct 2012 14:41:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ARM: dt: tegra: ventana: define pinmux for ddc
References: <1351147951-19706-1-git-send-email-markz@nvidia.com>
In-Reply-To: <1351147951-19706-1-git-send-email-markz@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 12:52 AM, Mark Zhang wrote:
> Tegra 2's I2C2 controller can be routed to either the PTA
> or DDC pin group on Ventana. So:
> - Remove the HDMI function definition of pta pingroup
> - Define child i2c adapters(ddc & pta) for I2C2 controller

Thanks, this looks good now.

I've applied it to Tegra's for-3.8/dt branch for now, although I may
have to shuffle things around (or just rename that branch) depending on
exactly what patches we end up with to enable tegradrm.
