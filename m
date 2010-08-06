Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862Ab0HFMiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:38:03 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:33610 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0HFMh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:37:57 -0400
Date: Fri, 6 Aug 2010 15:37:11 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] omap3: make coresight register save across OFF
 modes a sysfs option
Message-ID: <20100806123711.GI28519@shisha.kicks-ass.net>
Mail-Followup-To: Tony Lindgren <tony@atomide.com>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
 <1280077520-7538-8-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280077520-7538-8-git-send-email-virtuoso@slind.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 25, 2010 at 08:05:20 +0300, Alexander Shishkin wrote:
> This adds a sysfs file at /sys/power/coresight_save which is used to
> control if the ETM and debug components' states should be saved and
> restored across OFF modes.

The non-omap patches are merged to Russell's tree, so these three are
the only remaining.

This one won't apply to linux-omap master any more because of the pm44xx
in the makefile, but should be ok otherwise. It would still apply to
linus' tree.

So, should I rediff it, resend it or just drop it, because it's not needed?

Regards,
--
Alex
