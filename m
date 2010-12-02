Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab0LBJko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 04:40:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59115 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756971Ab0LBJkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 04:40:42 -0500
Date: Thu, 2 Dec 2010 09:40:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk, dahuang@nvidia.com,
        olofj@chromium.org
Subject: Re: [PATCH 0/4] Various tps6586x regulator fixes from ChromeOS
Message-ID: <20101202094038.GA19267@rakim.wolfsonmicro.main>
References: <1291235851-29523-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291235851-29523-1-git-send-email-swarren@nvidia.com>
X-Cookie: No directory.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 01:37:27PM -0700, Stephen Warren wrote:
> Following are some patches for the tps6586x regulator driver that were
> made in the ChromeOS repository.
> 
> A variety of people have built a kernel containing these patches, and
> booted Tegra Seaboard with that kernel.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

In general please do try to provide a bit more detail in your changelogs
- things like missing shifts are fairly obvious but...

>   regulator: tps6586x: Fix TPS6586X_DVM to store goreg/bit
>   regulator: tps6586x: Handle both enable reg/bits being the same

...things like these aren't obvious.

Please also note that the kernel does not use Gerritt.
