Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab0L2XnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:43:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56970 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0L2XnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:43:11 -0500
Message-ID: <4D1BC77C.3040205@zytor.com>
Date: Wed, 29 Dec 2010 15:42:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86: Change get_max_mapped() to inline
References: <4D0C072D.1040201@kernel.org>	<4D19320B.7030007@kernel.org>	<4D1933BA.8000508@kernel.org>	<4D1BBEB7.3010901@zytor.com>	<AANLkTineB4n7mjotECPK_VsHvP9xGt=SMJ-GSC_6nZAZ@mail.gmail.com> <AANLkTi=NU1UM3N6bbPSqqS+7UbvTY6YDNyn2s4tKURMY@mail.gmail.com>
In-Reply-To: <AANLkTi=NU1UM3N6bbPSqqS+7UbvTY6YDNyn2s4tKURMY@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2010 03:37 PM, Yinghai Lu wrote:
> 
> or could just use unsigned long instead.
> 
> on 32bit it will be under 4g
> on 64bit unsigned long  is 64bit already.
> 

This is true, although it seems fragile -- the whole terminology and the
differences between 32 and 64 bits are just a huge headache.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

