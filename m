Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3ABWGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:06:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41516 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3ABWGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:06:14 -0500
Message-ID: <50E4AF53.2000905@wwwdotorg.org>
Date: Wed, 02 Jan 2013 15:06:11 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 09/11] clk: tegra: add dt support
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com> <1356619644-18565-10-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1356619644-18565-10-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 07:47 AM, Prashant Gaikwad wrote:
> Add support to initialize clock from DT.

Rather than require every separate clock driver to create a header in
include/linux/clk/$socname.h, would it make sense to create a single
function that can initialize any enable SoC's clocks, using a scheme
similar to:

https://lkml.org/lkml/2012/11/20/706

That's in linux-next as of today, and Thomas Petazzoni was working on
something similar for irqchips. It probably wouldn't be too hard to do
the same for clock initialization?

