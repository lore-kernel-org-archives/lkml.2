Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2FLQI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:08:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57259 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2FLQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:08:56 -0400
Message-ID: <4FD76994.6060406@wwwdotorg.org>
Date: Tue, 12 Jun 2012 10:08:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: khali@linux-fr.org, w.sang@pengutronix.de, ben-linux@fluff.org,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 1/4] i2c: tegra: make sure register writes completes
References: <1339497451-26260-1-git-send-email-ldewangan@nvidia.com> <1339497451-26260-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1339497451-26260-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 04:37 AM, Laxman Dewangan wrote:
> The Tegra PPSB (an peripheral bus) queues writes transactions.
> In order to guarantee that writes have completed before a
> certain time, a read transaction to a register on the same
> bus must be executed.
> This is necessary in situations such as when clearing an
> interrupt status or enable, so that when returning from an
> interrupt handler, the HW has already de-asserted its
> interrupt status output, which will avoid spurious interrupts.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> changes from V1:
> 	Taken care of Wolfram's review comment.

That changelog is not very descriptive. By the time a patch is reposted,
the original reviewer may well have forgotten what comments they made,
and nobody else is going to remember since they didn't make the
comments. In other words, it's better to explicitly describe the changes
that were made, rather than who requested them.
