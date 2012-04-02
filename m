Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2DBT7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:59:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36556 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2DBT7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:59:00 -0400
Message-ID: <4F7A0500.3060305@wwwdotorg.org>
Date: Mon, 02 Apr 2012 13:58:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alok Chauhan <alokc@nvidia.com>
CC: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        olof@lixom.net, bones@secretlab.ca, omaplinuxkernel@gmail.com,
        ccross@android.com, ldewangan@nvidia.com, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, dgreid@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: tegra: Add delay before reset the controller
References: <1333345982-16595-1-git-send-email-alokc@nvidia.com>
In-Reply-To: <1333345982-16595-1-git-send-email-alokc@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 11:53 PM, Alok Chauhan wrote:
> NACK interrupt generated before I2C controller generates
> the STOP condition on bus. In Software, because of this
> reset of controller is happening before I2C controller could
> complete STOP condition. So wait for some time before resetting
> the controller so that STOP condition has delivered properly on bus.
> 
> Added delay of 2 clock period before reset the
> controller in case of NACK error.
> 
> Signed-off-by: Alok Chauhan <alokc@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
