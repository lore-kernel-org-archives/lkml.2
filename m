Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0KRA1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:27:17 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40660 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab0KRA1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:27:16 -0500
Subject: Re: [PATCH] ARM: tegra: timer: Separate clocksource and sched_clock
From: john stultz <johnstul@us.ibm.com>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1290039615-23407-1-git-send-email-ccross@android.com>
References: <1290039615-23407-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 16:27:08 -0800
Message-ID: <1290040028.2504.24.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 16:20 -0800, Colin Cross wrote:
> tegra_clocksource_read should not use cnt32_to_63, wrapping is
> already handled in the clocksource code.  Move the cnt32_to_63
> into the sched_clock function, and replace the use of clocksource
> mult and shift with a multiplication by 1000 to convert us to ns.
> 
> Change-Id: Ica1158c3fbed0ba53391f7db61180129a957511d
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: John Stultz <johnstul@us.ibm.com>


