Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab1DFWbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:31:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:57996 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab1DFWbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:31:20 -0400
Date: Thu, 7 Apr 2011 00:31:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Keith Packard <keithp@keithp.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
In-Reply-To: <yun1v1fj024.fsf@aiko.keithp.com>
Message-ID: <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6>
References: <yun1v1fj024.fsf@aiko.keithp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011, Keith Packard wrote:
> -rc2 was causing resume failures on my X201s -- the video mode would get
> reset, but the system would then lock up. I bisected the failure down to:
> 
> commit b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Thu Mar 24 20:16:42 2011 +0100
> 
>     Bluetooth: Fix warning with hci_cmd_timer
> 
> Reverting this on top of -rc2 makes resume reliable again.

Huch. I really have a hard time to connect this. Can you revert the
two hunks seperately?

Thanks,

	tglx

