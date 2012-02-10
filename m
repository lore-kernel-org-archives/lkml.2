Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054Ab2BJTz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:55:27 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:34613 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753Ab2BJTzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:55:25 -0500
From: Kevin Hilman <khilman@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 00/25] gpio/omap: driver cleanup and fixes
Organization: Texas Instruments, Inc.
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
	<20120210192416.GW1426@atomide.com>
Date: Fri, 10 Feb 2012 11:55:20 -0800
In-Reply-To: <20120210192416.GW1426@atomide.com> (Tony Lindgren's message of
	"Fri, 10 Feb 2012 11:24:16 -0800")
Message-ID: <87ty2yxy3b.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren <tony@atomide.com> writes:

[...]

> ..but are there also some patches in your series that should also be
> applied separately as fixes for the -rc cycle?

IMO, there aren't any things in this series that fall into the
regression category.

After I get to a final review and test of this (early next week), I'm
planning to sent a pull request to Grant.

Kevin
