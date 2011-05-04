Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1EDPD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:03:57 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19846 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390Ab1EDPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:03:55 -0400
From: <oskar.andero@sonyericsson.com>
Date: Wed, 4 May 2011 17:03:52 +0200
To: "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Boivie, Victor" <Victor.Boivie@sonyericsson.com>,
        <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] ARM: Allow for kernel command line concatenation
Message-ID: <20110504150352.GA19335@caracas.corpusers.net>
References: <1302255383-12375-1-git-send-email-oskar.andero@sonyericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1302255383-12375-1-git-send-email-oskar.andero@sonyericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

On 11:36 Fri 08 Apr, oskar.andero@sonyericsson.com wrote:
> From: Victor Boivie <victor.boivie@sonyericsson.com>
> 
> This patch allows the provided CONFIG_CMDLINE to be concatenated
> with the one provided by the boot loader. This is useful to
> merge the static values defined in CONFIG_CMDLINE with the
> boot loader's (possibly) more dynamic values, such as startup
> reasons and more.
> 
> Signed-off-by: Victor Boivie <victor.boivie@sonyericsson.com>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@sonyericsson.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> Acked-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
> ---
Uwe, would you consider merging this patch to your tree or would you
prefer it to go through another maintainer?

Thanks,
-Oskar

