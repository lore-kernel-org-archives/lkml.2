Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab1D0V2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:28:53 -0400
Received: from www.xplot.org ([66.92.66.146]:47989 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab1D0V2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:28:52 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: maciej.rutecki@gmail.com, rjw@sisk.pl
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc3 udevadm settle timeout, many hdb events, interrupt storm 
In-reply-to: Your message of Sun, 17 Apr 2011 19:12:45 +0200.
             <201104171912.45583.maciej.rutecki@gmail.com> 
Date: Wed, 27 Apr 2011 17:28:17 -0400
Message-Id: <E1QFCHR-0001Iw-00@www.xplot.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I tested 2.6.39-rc5 today and this bug appears to be fixed.... no
delay on bootup, "udevadm monitor" shows no spurious events, and
monitoring /proc/interrupts I see no ide-related interrupt storm.

I added a comment at https://bugzilla.kernel.org/show_bug.cgi?id=33412
but I could not figure out how to mark this bug closed/fixed, even
though I was logged in.

Please mark this bug closed and/or fixed (in 2.6.39-rc5).

			-Tim Shepard
			 shep@alum.mit.edu
