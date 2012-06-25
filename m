Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2FYJsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:48:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13224 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab2FYJsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:48:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 25 Jun 2012 02:48:06 -0700
Message-ID: <4FE83374.6090608@nvidia.com>
Date: Mon, 25 Jun 2012 15:16:28 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: Re: [PATCH] i2c: tegra: use clk_disable_unprepare in place of clk_disable
References: <1340196960-3002-1-git-send-email-ldewangan@nvidia.com> <4FE1F9A0.6080200@wwwdotorg.org> <4FE1F9D6.6090802@wwwdotorg.org>
In-Reply-To: <4FE1F9D6.6090802@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Wednesday 20 June 2012 09:57 PM, Stephen Warren wrote:
> On 06/20/2012 10:26 AM, Stephen Warren wrote:
>> On 06/20/2012 06:56 AM, Laxman Dewangan wrote:
>>> Use clk_disable_unprepare() inplace of clk_disable().
>>> This was missed as part of moving clock enable/disable to
>>> prepare/unprepare for using the common clock framework.
> ...
>> I see no reason not to take the second patch in the series through the
>> I2C tree though.
> Uggh. Ignore that paragraph - the other patch was sent separately not as
> a series.

so are you taking care of this patch or do I need to send the patch 
based on your tree in place of linux-next?

