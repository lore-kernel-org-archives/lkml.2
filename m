Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2GTOFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:05:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41935 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2GTOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:05:31 -0400
Date: Fri, 20 Jul 2012 15:09:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: <linuxppc-dev@lists.ozlabs.org>, <galak@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH] mpc85xx_defconfig: add IDE support for MPC85xxCDS
Message-ID: <20120720150900.082afc7c@pyramind.ukuu.org.uk>
In-Reply-To: <1342788325-27609-1-git-send-email-chenhui.zhao@freescale.com>
References: <1342788325-27609-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012 20:45:25 +0800
Zhao Chenhui <chenhui.zhao@freescale.com> wrote:

> Add IDE support for MPC85xxCDS.
> 
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
>  arch/powerpc/configs/mpc85xx_defconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
> index 03ee911..45eda33 100644
> --- a/arch/powerpc/configs/mpc85xx_defconfig
> +++ b/arch/powerpc/configs/mpc85xx_defconfig
> @@ -105,6 +105,8 @@ CONFIG_BLK_DEV_RAM=y
>  CONFIG_BLK_DEV_RAM_SIZE=131072
>  CONFIG_MISC_DEVICES=y
>  CONFIG_EEPROM_LEGACY=y
> +CONFIG_IDE=y
> +CONFIG_BLK_DEV_VIA82CXXX=y

CONFIG_IDE is obsolete we shouldn't be adding it to anything as it will
eventually go away. Please use the ATA drivers.
