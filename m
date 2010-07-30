Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab0G3MQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 08:16:35 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:52146 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab0G3MQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 08:16:33 -0400
Date: Fri, 30 Jul 2010 15:16:00 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Richard Woodruff <r-woodruff2@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH 6/7] save and restore etm state across core OFF modes
Message-ID: <20100730121600.GI14399@shisha.kicks-ass.net>
Mail-Followup-To: linux-arm-kernel@lists.infradead.org,
	Richard Woodruff <r-woodruff2@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
 <1280077520-7538-7-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280077520-7538-7-git-send-email-virtuoso@slind.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 25, 2010 at 08:05:19 +0300, Alexander Shishkin wrote:
> This prevents ETM stalls whenever core enters OFF mode. Original patch
> author is Richard Woodruff <r-woodruff2@ti.com>.
> 
> This version of the patch makes use of the ETM OS save/restore mechanism,
> which takes about 55 words in omap3_arm_context[] instead of 128. Also,
> saving ETM context can be switched on/off at runtime.

Can I have some (n)acks on this one and 7/7 as well?

Regards,
--
Alex
