Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2H1RVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:21:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50187 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2H1RVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:21:04 -0400
Message-ID: <503CFDFC.7060607@nvidia.com>
Date: Tue, 28 Aug 2012 10:21:00 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] gpio: tegra: remove useless includes of <mach/*.h>
References: <1346137196-7138-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1346137196-7138-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 11:59 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Nothing from these files is needed, so remove the includes. This helps
> single zImage work by reducing use of the mach-tegra/include/mach/
> directory.

BTW, it'd be easiest for me to take this through the Tegra tree, since I
may be able to delete <mach/suspend.h> after this.

