Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0FPWFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 18:05:40 -0400
Received: from daytona.panasas.com ([67.152.220.89]:20336 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752719Ab0FPWFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 18:05:39 -0400
Message-ID: <4C194AB2.7050707@panasas.com>
Date: Wed, 16 Jun 2010 18:05:38 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Makefile asking for mrproper on new checkout with KBUILD_OUTPUT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2010 22:05:39.0003 (UTC) FILETIME=[0DF130B0:01CB0DA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I get this problem: When a few Header files are changed, like when doing
a git checkout the Makefile is complaining about mrproper needed.

Now I'm building a:
	make ARCH=arch KBUILD_OUTPUT=.build_arch/

But a: 
	make ARCH=arch KBUILD_OUTPUT=.build_arch/ mrproper

Will not help. What the Makefile wants is a:
	make mrproper

doing the "make mrproper" does solves it.
It used to be fine, I'm not sure when it started to break.

How can I debug this to see what is the offending files?

Thanks
Boaz

