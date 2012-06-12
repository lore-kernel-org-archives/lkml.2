Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab2FLOLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2FLOLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:11:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Lee Susman <lsusman@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 1/1] block: Add eMMC4.5 packed commands unit-tests
References: <1339494088-29126-1-git-send-email-merez@codeaurora.org>
	<1339494088-29126-2-git-send-email-merez@codeaurora.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 12 Jun 2012 10:11:16 -0400
In-Reply-To: <1339494088-29126-2-git-send-email-merez@codeaurora.org> (Maya
	Erez's message of "Tue, 12 Jun 2012 12:41:28 +0300")
Message-ID: <x491ulkk4cb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> writes:

> Expose the following packed commands tests:
> - Test the write packed commands list preparation
> - Simulate a returned error code
> - Send an invalid packed command to the card
>
> Signed-off-by: Lee Susman <lsusman@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
>
> diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
> index 3b1f783..bbe8cac 100644
> --- a/drivers/mmc/card/Kconfig
> +++ b/drivers/mmc/card/Kconfig
> @@ -67,3 +67,14 @@ config MMC_TEST
>  
>  	  This driver is only of interest to those developing or
>  	  testing a host driver. Most people should say N here.
> +
> +config MMC_BLOCK_TEST
> +	tristate "MMC block test"
> +	depends on MMC_BLOCK && IOSCHED_TEST

Umm, if this depends on your iosched-test patch, then you should make
them both part of a patch series.  It would have answered one of my
questions on that patch.

Cheers,
Jeff
