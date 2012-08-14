Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2HNQtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:49:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34860 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2HNQtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:49:10 -0400
Message-ID: <502A817C.4000601@wwwdotorg.org>
Date: Tue, 14 Aug 2012 10:49:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, w.sang@pengutronix.de
CC: khali@linux-fr.org, swarren@nvidia.com, olof@lixom.net,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: I2_M_NOSTART functionality not supported
 in Tegra20
References: <1344935949-26709-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344935949-26709-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 03:19 AM, Laxman Dewangan wrote:
> Tegra20 i2c controller does not support the continue transfer
> which implements the I2C_M_NOSTART functionality of i2c
> protocol mangling.
> Removing the I2C_M_NOSTART functionality for Tegra20.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reported-by: Stephen Warren <swarren@nvidia.com>

Tested-by: Stephen Warren <swarren@wwwdotorg.org>

Note that if I take Laxman's I2C driver clock patches through the Tegra
tree, and Wolfram takes this patch through the I2C tree, there will be a
very slight conflict, since adjacent lines are touched. However, the
resolution is simple and obvious, so I think that's fine.
