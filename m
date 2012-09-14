Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2INAHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 20:07:02 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:36546
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333Ab2INAHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 20:07:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd24he5bhf0ah107ah1220h1288h12a5h12a9h12bdh1315h1155h)
Date: Thu, 13 Sep 2012 19:04:39 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Shaohui Xie <Shaohui.Xie@freescale.com>
CC: <linux-edac@vger.kernel.org>, <avorontsov@mvista.com>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] edac/85xx: fix error handle of mpc85xx_mc_err_probe
Message-ID: <20120913190439.64ef56f8566328b23f3843db@freescale.com>
In-Reply-To: <1347533729-5893-1-git-send-email-Shaohui.Xie@freescale.com>
References: <1347533729-5893-1-git-send-email-Shaohui.Xie@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2012 18:55:29 +0800
Shaohui Xie <Shaohui.Xie@freescale.com> wrote:

> Error handle in case of DDR ECC off is wrong, sysfs entries have not been
> created, so edac_mc_free which frees a mci instance should not be called.
> Also, free mci's memory in this case.
> 
> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> ---

this fixes a 'WARNING: at lib/kobject.c:593' on a p2020, so:

Tested-by: Kim Phillips <kim.phillips@freescale.com>

Kim

