Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2GBNyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab2GBNyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:54:06 -0400
Message-ID: <4FF1A7DD.4020003@redhat.com>
Date: Mon, 02 Jul 2012 09:53:33 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2][RFC] Potential fix for leapsecond caused futex issue
 (v2)
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com> <4FF11FCB.4030207@us.ibm.com>
In-Reply-To: <4FF11FCB.4030207@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/02/2012 12:12 AM, John Stultz wrote:
> On 07/01/2012 11:29 AM, John Stultz wrote:
>> TODOs:
>> * Chase down the futex/hrtimer interaction to see if this could
>> be triggered in any other way.
>> * Get Tglx's input/ack
>> * Generate a backport for pre-v3.4 kernels
> So while still waiting for feedback on the clock_was_set() change, I went ahead
> and generated backports for most of the stable kernels on kernel.org.
> 

I've tested on a well-known enterprise distro ;), as well as it's more public
variant with the latest top-of-tree kernel + this second patchset across a
fairly wide selection of systems [AMD and Intel, large and small] and don't see
any issues.

(I haven't taken tglx's comments into account yet though ... this is just an
indication that the direction of the patch seems correct)

P.
