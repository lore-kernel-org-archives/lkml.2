Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2JWQRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:17:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60252 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2JWQRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:17:47 -0400
Message-ID: <5086C328.2080705@wwwdotorg.org>
Date: Tue, 23 Oct 2012 10:17:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2] pinctrl/nomadik: use irq_create_mapping()
References: <1350981339-13316-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1350981339-13316-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 02:35 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Since in the DT case, the linear domain path will not allocate
> descriptors for the IRQs, we need to use irq_create_mapping()
> for mapping hwirqs to Linux IRQs, so these descriptors get
> created on-the-fly in this case.
> 
> ChangeLog v1->v2:
> 
> - Just use irq_create_mapping() in the .to_irq function since
>   this is called before unmasking or enabling any interrupt
>   lines, so irq_find_mapping() should be sufficient for the
>   IRQ handler function.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
