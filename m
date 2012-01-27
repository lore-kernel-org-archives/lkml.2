Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2A0LlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:41:16 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53703 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab2A0LlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:41:15 -0500
Date: Fri, 27 Jan 2012 11:42:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Anton Vorontsov" <cbouatmailru@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] lp8727_charger: change description about company
Message-ID: <20120127114235.36b985cd@pyramind.ukuu.org.uk>
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812D6EB06@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812D6EB06@EXMAIL03.scwf.nsc.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 22:58:15 -0800
"Kim, Milo" <Milo.Kim@ti.com> wrote:

> TI acquired National semiconductor at 2011.
> : National semiconductor -> Texas Instruments
> 
> Add driver information in the header file.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/power/lp8727_charger.c |    4 ++--
>  include/linux/lp8727.h         |    4 +++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
> index b15b575..97be22e 100755
> --- a/drivers/power/lp8727_charger.c
> +++ b/drivers/power/lp8727_charger.c
> @@ -1,7 +1,7 @@
>  /*
>   * Driver for LP8727 Micro/Mini USB IC with intergrated charger
>   *
> - *			Copyright (C) 2011 National Semiconductor
> + *			Copyright (C) 2011 Texas Instruments
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -488,7 +488,7 @@ static void __exit lp8727_exit(void)
>  module_init(lp8727_init);
>  module_exit(lp8727_exit);
>  
> -MODULE_DESCRIPTION("National Semiconductor LP8727 charger driver");
> +MODULE_DESCRIPTION("Texas Instruments LP8727 charger driver");

This may confuse people into thinking only the current TI branded version
works ? I wonder if it should give both names ?
