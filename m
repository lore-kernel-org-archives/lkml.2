Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2GWSYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:24:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48947 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2GWSYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:24:45 -0400
Message-ID: <500D96E6.4060507@wwwdotorg.org>
Date: Mon, 23 Jul 2012 12:24:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: w.sang@pengutronix.de, khali@linux-fr.org, ben-linux@fluff.org,
        swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH 5/5] i2c: tegra: convert normal suspend/resume to *_noirq
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com> <1341919244-23327-6-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1341919244-23327-6-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 05:20 AM, Laxman Dewangan wrote:
> To provide the late suspend and early resume for i2c
> driver, convert the suspend/resume as
> 	suspend-> suspend_noirq
> 	resume -> resume_noirq
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Why do we need this change?

IIRC, I proposed it before solely to solve some suspend/resume ordering
issues, and Colin Cross NAKd it. These days, deferred probe should make
this change unnecessary.

Unless there's a really good reason for this change, I'd tend to request
reverting it.
