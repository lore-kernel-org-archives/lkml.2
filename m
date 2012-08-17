Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab2HQVgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:36:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59234 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2HQVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:35:53 -0400
Message-ID: <502EB936.1000208@wwwdotorg.org>
Date: Fri, 17 Aug 2012 15:35:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, w.sang@pengutronix.de
CC: khali@linux-fr.org, swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        olof@lixom.net
Subject: Re: [PATCH REBASE 1/2] i2c: tegra: I2_M_NOSTART functionality not
 supported in Tegra20
References: <1345230155-4252-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1345230155-4252-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 01:02 PM, Laxman Dewangan wrote:
> Tegra20 i2c controller does not support the continue transfer
> which implements the I2C_M_NOSTART functionality of i2c
> protocol mangling.
> Removing the I2C_M_NOSTART functionality for Tegra20.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

I tested both these patches and they work fine. I'll hold off applying
them for a while for Wolfram to ack them.

