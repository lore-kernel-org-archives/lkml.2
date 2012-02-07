Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab2BGWMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:12:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41903 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187Ab2BGWMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:12:01 -0500
Message-ID: <4F31A1A2.8020201@zytor.com>
Date: Tue, 07 Feb 2012 14:11:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] x86, mm: Probe memory block size for generic x86
 64bit
References: <1327911855-6501-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1327911855-6501-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 12:24 AM, Yinghai Lu wrote:
> Usually if the system support memory remapping to get back memory for mmio
> range, we will have 128M ... 2G at the end.
> 
> Try to probe that size.
> 
> So we can get less entries in /sys/devices/system/memory/
> 
> -v2: don't probe it every time when /sys/../block_size_byte is showed...
> 

Okay... what on Earth is the point of this?

This just screams "dangerous toxic heuristic that's likely to break
unusual configurations", and reducing the number of entries in a /sys
directory is hardly motivation for anything.

You need a much better description of what you're trying to accomplish
and why that matters in the first place.

	-hpa
