Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3AIOnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:43:50 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19959 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab3AIOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:43:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 09 Jan 2013 06:42:53 -0800
Date: Wed, 9 Jan 2013 16:41:50 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 04/11] ARM: Tegra: Define Tegra30 CAR binding
Message-ID: <20130109144150.GS26066@tbergstrom-lnx.Nvidia.com>
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
 <1356619644-18565-5-git-send-email-pgaikwad@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1356619644-18565-5-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 03:47:17PM +0100, Prashant Gaikwad wrote:
> The device tree binding models Tegra30 CAR (Clock And Reset)
> as a single monolithic clock provider.
> 
...

> +  8	gpio

This clock isn't defined further on though...

Cheers,

Peter.
