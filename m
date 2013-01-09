Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab3AIPmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:42:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11563 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3AIPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:42:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Jan 2013 07:42:42 -0800
Date: Wed, 9 Jan 2013 17:42:00 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 04/11] ARM: Tegra: Define Tegra30 CAR binding
Message-ID: <20130109154200.GA29605@tbergstrom-lnx.Nvidia.com>
References: <1356260751-3667-1-git-send-email-pgaikwad@nvidia.com>
 <1356260751-3667-5-git-send-email-pgaikwad@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1356260751-3667-5-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 12:05:44PM +0100, Prashant Gaikwad wrote:
> The device tree binding models Tegra30 CAR (Clock And Reset)
> as a single monolithic clock provider.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

...

> +  81	i2cslow

...

> +  217	i2cslow

I guess 81 is the correct number?

Cheers,

Peter.
