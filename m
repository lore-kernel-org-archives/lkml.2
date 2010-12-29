Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0L2Xuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:50:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52448 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0L2Xup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:50:45 -0500
Message-ID: <4D1BC94C.5040100@zytor.com>
Date: Wed, 29 Dec 2010 15:50:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable to local node memory
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org> <4D1933D1.9020609@kernel.org> <4D1BC856.4010202@kernel.org>
In-Reply-To: <4D1BC856.4010202@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2010 03:46 PM, Yinghai Lu wrote:
> 
> -v2: update it to recent numa-emulation change
> 

Lovely, yet another interbranch conflict.  This makes me very concerned.

What is the delta between these?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
