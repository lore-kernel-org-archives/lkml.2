Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293Ab2CIV4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:56:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42901 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab2CIV4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:56:44 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] trivial: spi-pl022.c: fix a wrong kerneldoc comment
To: Federico Vaga <federico.vaga@gmail.com>, trivial@kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, giancarlo.asnaghi@st.com,
        Federico Vaga <federico.vaga@gmail.com>
In-Reply-To: <1328718213-17375-1-git-send-email-federico.vaga@gmail.com>
References: <1328718213-17375-1-git-send-email-federico.vaga@gmail.com>
Date: Fri, 09 Mar 2012 14:56:41 -0700
Message-Id: <20120309215641.287F83E0880@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Feb 2012 17:23:33 +0100, Federico Vaga <federico.vaga@gmail.com> wrote:
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> ---
>  drivers/spi/spi-pl022.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> index 2f9cb43..286572d 100644
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@ -1495,7 +1495,7 @@ out:
>  
>  /**
>   * pump_messages - Workqueue function which processes spi message queue
> - * @data: pointer to private data of SSP driver
> + * @work: pointer to the pump_messages work structure within pl022 structure
>   *
>   * This function checks if there is any spi message in the queue that
>   * needs processing and delegate control to appropriate function

Patch obsolete after applying the core-queuing patch from Linus

g.

> -- 
> 1.7.7.6
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
