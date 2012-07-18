Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab2GRAet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:34:49 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54802 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab2GRAeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:34:37 -0400
Message-ID: <50060496.2090909@us.ibm.com>
Date: Tue, 17 Jul 2012 17:34:30 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 2.6.32-stable: Fix for leapsecond deadlock & hrtimer/futex
 issue
References: <1342562735-55870-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1342562735-55870-1-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071800-7282-0000-0000-00000B05B5AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 03:05 PM, John Stultz wrote:
> This is the last backport I have ready at this time. I realize there's
> still the 2.6.27 tree, but if I recall correctly I had some trouble
> getting that booted in my test environment. I can take a swing at
> backporting it, but I may need a hand with testing.

And if anyone is interested in helping test, I've got a first pass 
(builds & mostly boots) of the 2.6.27-stable backports here:
git://git.linaro.org/people/jstultz/linux.git leapfix/2.6.27.62

http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/leapfix/2.6.27.62

Unfortunately I run into udev issues trying to boot this on my more 
recent test environment.

thanks
-john

