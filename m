Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1K1Tdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:33:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:19883 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab1K1Tda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,585,1315206000"; 
   d="scan'208";a="41827312"
From: Andi Kleen <andi@firstfloor.org>
To: "Nicolas Kalkhof" <nkalkhof@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Too many poll_idle cpu calls in kernel 3.2 rc-series
References: <1587582695.5658131.1322424808507.JavaMail.fmail@mwmweb005>
Date: Mon, 28 Nov 2011 11:33:28 -0800
In-Reply-To: <1587582695.5658131.1322424808507.JavaMail.fmail@mwmweb005>
	(Nicolas Kalkhof's message of "Sun, 27 Nov 2011 21:13:28 +0100 (CET)")
Message-ID: <m28vn03uuv.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Nicolas Kalkhof" <nkalkhof@web.de> writes:

> the kernel v3.2 series shows excessive poll_idle calls during system idle phases causing the cpu
> (mobile i7 2620M) to heat up and draw additional 10% more power.  All kernel versions between
> 3.2-rc1 and 3.2-rc3 are affected. Perf Top and Powertop both show the same issue.
> I've posted a similar bug report before: http://marc.info/?l=linux-kernel&m=132164909313594&w=2
> and used perf top -U to verify the poll_idle calls as requested.

So it didn't happen with earlier kernels? 
I would suggest a git bisect in this case.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
