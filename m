Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2DSAH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:07:29 -0400
Received: from void.printf.net ([89.145.121.20]:45519 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab2DSAH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:07:27 -0400
From: Chris Ball <cjb@laptop.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pavan Kunapuli <pkunapuli@nvidia.com>, swarren@nvidia.com,
        paul.gortmaker@windriver.com, olof@lixom.net,
        rmk+kernel@arm.linux.org.uk, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] mmc: tegra: support SDHCI SPEC 300
References: <1334755082-26818-1-git-send-email-pkunapuli@nvidia.com>
	<4F8EF151.8050808@wwwdotorg.org>
Date: Wed, 18 Apr 2012 20:07:24 -0400
In-Reply-To: <4F8EF151.8050808@wwwdotorg.org> (Stephen Warren's message of
	"Wed, 18 Apr 2012 10:52:33 -0600")
Message-ID: <87k41clh37.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 18 2012, Stephen Warren wrote:
> On 04/18/2012 07:18 AM, Pavan Kunapuli wrote:
>> Tegra3 SDHOST controller doesn't advertise
>> v3.00 support by default. This support has to
>> be enabled by configuring a vendor register in
>> the tegra3 sd host address space.
>> 
>> Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>
>
> FWIW,
>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Thanks, pushed to mmc-next for 3.5.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
