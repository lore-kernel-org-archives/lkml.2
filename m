Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3ABWKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:10:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44204 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3ABWKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:10:01 -0500
Message-ID: <50E4B036.6080205@wwwdotorg.org>
Date: Wed, 02 Jan 2013 15:09:58 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>, mturquette@linaro.org
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 00/11] Migrate Tegra to common clock framework
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 07:47 AM, Prashant Gaikwad wrote:
> This patchset does following:
> 1. Decompose single tegra clock structure into multiple clocks.
> 2. Try to use standard clock types supported by common clock framework.
> 3. Use dynamic initialization.
> 4. Move all clock code to drivers/clk/tegra from mach-tegra.
> 5. Add device tree support for Tegra20 and Tegra30 clocks.
> 6. Remove all legacy clock code from mach-tegra.

Mike,

Aside from a couple of small issues I just pointed out, this series
looks reasonable to me. I'd like to take it through the Tegra tree since
it might open up opportunities for other cleanup, and it has far more
dependencies-on/conflicts-with other changes there than the drivers/clk
tree. So, I'm looking for your ack when you can. Thanks.
