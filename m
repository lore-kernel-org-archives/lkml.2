Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0ILLVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 07:21:08 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:42124 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab0ILLVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 07:21:07 -0400
Date: Sun, 12 Sep 2010 12:21:05 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Corentin Chary <corentincj@iksaif.net>, fweisbec <fweisbec@gmail.com>
Subject: Re: EeePC 900 reboots/hangs when using using perf -a -f -g
Message-ID: <20100912112105.GA28420@sucs.org>
References: <20100912102854.GA7359@sucs.org> <1284289027.2251.95.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284289027.2251.95.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 12:57:07PM +0200, Peter Zijlstra wrote:
> 
> Bisect it?

.35 shows the same issue (although I didn't recompile my perf binary). I
don't know if this is a regression - it might always have been there...

> Does .35 work? If so, you could try it with the .35 version of
> eeepc-laptop driver to see if its something specific to that driver, or
> if its something we did to the stack unwinding code.
> 
> Most curious issue..

It certainly is weird. When the machine reboots I notice that the
backlight is not at its normal level as if something was dimming the
display (perhaps X turns off the backlight and turns off the display
when powersaving these days?). As the only backlight driver on my system
is in eeepc-laptop that's why I removed it.

-- 
Sitsofe | http://sucs.org/~sits/
