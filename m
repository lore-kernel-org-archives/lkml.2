Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab2CHKYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:24:06 -0500
Received: from edge10.ethz.ch ([82.130.75.186]:55394 "EHLO edge10.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab2CHKYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:24:03 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2012 05:24:03 EST
From: Thomas Rast <trast@inf.ethz.ch>
To: Junio C Hamano <gitster@pobox.com>
CC: <git@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git 1.7.10-rc0
References: <7v7gyvkh84.fsf@alter.siamese.dyndns.org>
Date: Thu, 8 Mar 2012 11:17:50 +0100
In-Reply-To: <7v7gyvkh84.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
	message of "Wed, 07 Mar 2012 17:35:07 -0800")
Message-ID: <87y5rbpfap.fsf@thomas.inf.ethz.ch>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [129.132.153.233]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

>  * Parallel to the test suite, there is a beginning of performance
>    benchmarking framework.

I just noticed that this does not work on OS X; its 'time' does not
support the -f option.  For now I think I'm happy; it can compare
several versions of Git on Linux to detect performance improvements or
regressions.  Comparability across systems or platforms was never a main
goal.

In the long run we'll have to change it to either use 'time -p'
everywhere and parse that into shape -- at least GNU and OS X agree on
what POSIX specifies ;-) -- or just supply a small helper utility that
does the timings for us in a ready-to-use format.

-- 
Thomas Rast
trast@{inf,student}.ethz.ch
