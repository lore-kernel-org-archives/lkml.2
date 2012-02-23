Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2BWOEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:04:41 -0500
Received: from science.horizon.com ([71.41.210.146]:21404 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753084Ab2BWOEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:04:40 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 09:04:39 EST
Date: 23 Feb 2012 08:57:58 -0500
Message-ID: <20120223135758.8611.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/5] i387: math_state_restore() isn't called from asm
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * Must be called with kernel preemption disabled (eg with local
> + * local interrupts as in the case of do_device_not_available).

"eg with local local interrupts"?

As long as I'm quibbling, "exempli gratia" deserves periods to make the
abbreviation, and a parenthetical comment at the end of a sentence is
usually better set off with a comma.

+ * Must be called with kernel preemption disabled, e.g. with local
+ * interrupts disabled as in the case of do_device_not_available.
