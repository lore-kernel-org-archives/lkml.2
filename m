Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab2GBEOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:14:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40669 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2GBEOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:14:09 -0400
Message-ID: <4FF11FCB.4030207@us.ibm.com>
Date: Sun, 01 Jul 2012 21:12:59 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2][RFC] Potential fix for leapsecond caused futex issue
 (v2)
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12070204-7282-0000-0000-00000A7C6F44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 11:29 AM, John Stultz wrote:
> TODOs:
> * Chase down the futex/hrtimer interaction to see if this could
> be triggered in any other way.
> * Get Tglx's input/ack
> * Generate a backport for pre-v3.4 kernels
So while still waiting for feedback on the clock_was_set() change, I 
went ahead and generated backports for most of the stable kernels on 
kernel.org.

Clearly these shouldn't go anywhere until the fix is upstream, but since 
I assume there's a number of distro developers who are likely under 
pressure to have a fix soon, I wanted to make them available so no one 
is duplicating work.

You can find them here:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=summary

I did boot and test each of those kernels with my leaptest-timer.c test 
successfully.

thanks
-john


