Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0DTUxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:53:24 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56134 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab0DTUxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:53:22 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Michael Ellerman <michael@ellerman.id.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       adobriyan@gmail.com, Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vUB.fSSzLB@tosh>
	<alpine.DEB.2.01.1004192339190.13016@bogon.housecafe.de>
	<1271765898.4324.2.camel@concordia>
	<alpine.DEB.2.01.1004201104170.13016@bogon.housecafe.de>
X-Yow: It's hard being an ARTIST!!
Date: Tue, 20 Apr 2010 22:53:19 +0200
In-Reply-To: <alpine.DEB.2.01.1004201104170.13016@bogon.housecafe.de>
	(Christian Kujau's message of "Tue, 20 Apr 2010 11:15:05 -0700 (PDT)")
Message-ID: <m2k4s1hmm8.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.96 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau <lists@nerdbynature.de> writes:

> +	while ((p = strstr(p, "/")))

You want to use strchr.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
