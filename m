Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab1HXXpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:45:45 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50999 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab1HXXpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:45:44 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Runtime: Correct documentation of pm_runtime_irq_safe()
Organization: Texas Instruments, Inc.
References: <201108242246.41574.rjw@sisk.pl>
Date: Wed, 24 Aug 2011 16:45:41 -0700
In-Reply-To: <201108242246.41574.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 24 Aug 2011 22:46:41 +0200")
Message-ID: <87wre25q6y.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The description of pm_runtime_irq_safe() has to be updated to follow
> the code after commit 02b2677 (PM / Runtime: Allow _put_sync() from
> interrupts-disabled context).

oops, missed updating that part of the doc.

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Kevin Hilman <khilman@ti.com>

