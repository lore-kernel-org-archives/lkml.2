Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2KIRA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:00:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41945 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab2KIRAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:00:52 -0500
Message-ID: <509D36C0.8010109@wwwdotorg.org>
Date: Fri, 09 Nov 2012 10:00:48 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2] gpio: tegra: read output value when gpio is set in
 direction_out
References: <1352441060-31559-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1352441060-31559-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 11:04 PM, Laxman Dewangan wrote:
> Read the output value when gpio is set for the output mode for
> gpio_get_value(). Reading input value in direction out does not
> give correct value.

Acked-by: Stephen Warren <swarren@nvidia.com>

