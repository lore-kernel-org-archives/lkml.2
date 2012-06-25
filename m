Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2FYPzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:55:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42084 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2FYPzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:55:06 -0400
Message-ID: <4FE889D6.4030500@wwwdotorg.org>
Date: Mon, 25 Jun 2012 09:55:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: Re: [PATCH] i2c: tegra: use clk_disable_unprepare in place of clk_disable
References: <1340196960-3002-1-git-send-email-ldewangan@nvidia.com> <4FE1F9A0.6080200@wwwdotorg.org> <4FE1F9D6.6090802@wwwdotorg.org> <4FE83374.6090608@nvidia.com>
In-Reply-To: <4FE83374.6090608@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 03:46 AM, Laxman Dewangan wrote:
> Stephen,
> 
> On Wednesday 20 June 2012 09:57 PM, Stephen Warren wrote:
>> On 06/20/2012 10:26 AM, Stephen Warren wrote:
>>> On 06/20/2012 06:56 AM, Laxman Dewangan wrote:
>>>> Use clk_disable_unprepare() inplace of clk_disable().
>>>> This was missed as part of moving clock enable/disable to
>>>> prepare/unprepare for using the common clock framework.
>> ...
>>> I see no reason not to take the second patch in the series through the
>>> I2C tree though.
>> Uggh. Ignore that paragraph - the other patch was sent separately not as
>> a series.
> 
> so are you taking care of this patch or do I need to send the patch
> based on your tree in place of linux-next?

Yes, this patch should be applied through the Tegra tree, since it will
be a dependency of the common clock framework switchover there, which I
hope to take place this kernel cycle.

I did just attempt to apply this patch to the for-3.6/common-clk branch,
but it doesn't apply:-( Could you please rebase and resend. Thanks.
