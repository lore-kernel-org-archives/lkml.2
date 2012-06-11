Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2FKUhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:37:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65313 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2FKUhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:37:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6739"; a="197629993"
Date: Mon, 11 Jun 2012 13:37:48 -0700
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Eric Miao <eric.y.miao@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paulo Marques <pmarques@grupopie.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jon Masters <jonathan@jonmasters.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: two possible fixes for the KALLSYMS build problem
Message-ID: <20120611203748.GA16967@codeaurora.org>
References: <1338567721-19514-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338567721-19514-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 09:21:59AM -0700, David Brown wrote:

> David Brown (1):
>   ARM: Prevent KALLSYM size mismatch on ARM.
> 
>  arch/arm/kernel/vmlinux.lds.S |    3 +++
>  1 file changed, 3 insertions(+)

Just wondering if anyone has had a chance to look at either of these,
or try them.  I haven't seen any KALLSYMS mismatch build errors with
either of these patches applied.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
