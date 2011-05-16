Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1EPKQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:16:30 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:52198 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481Ab1EPKQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:16:28 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 8/9] OMAP1 / PM: Use generic clock manipulation routines for runtime PM
Organization: Texas Instruments, Inc.
References: <201104130205.26988.rjw@sisk.pl> <201104170135.19388.rjw@sisk.pl>
	<201104242330.13607.rjw@sisk.pl> <201104242343.41456.rjw@sisk.pl>
Date: Mon, 16 May 2011 12:16:13 +0200
In-Reply-To: <201104242343.41456.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sun, 24 Apr 2011 23:43:41 +0200")
Message-ID: <87mxindk7m.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Convert OMAP1 to using the new generic clock manipulation routines
> and a device power domain for runtime PM instead of overriding the
> platform bus type's runtime PM callbacks.  This allows us to simplify
> OMAP1-specific code and to share some code with other platforms
> (shmobile in particular).
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Kevin Hilman <khilman@ti.com>

