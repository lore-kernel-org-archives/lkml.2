Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2GFISr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:18:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23392 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2GFISn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:18:43 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18MaSEQaH32Bwmxspzi+jz5
Date: Fri, 6 Jul 2012 01:18:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, "Cousson, Benoit" <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v2 REPOST 4/4] ARM: OMAP2+: dmtimer: cleanup fclk usage
Message-ID: <20120706081840.GM1122@atomide.com>
References: <1341492059-5544-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341492059-5544-1-git-send-email-tarun.kanti@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tarun Kanti DebBarma <tarun.kanti@ti.com> [120705 05:45]:
> With omap_hwmod_get_main_clk() now available, this can be passed to
> clk_get() to extract the fclk and thus avoid construction of fclk name.
> Corrected the timer fck name mis-match between clock44xx_data.c and
> omap_hwmod_44xx_data.c. For other platforms this is already taken care.

Thanks applying into cleanup-part2 branch.

Tony
