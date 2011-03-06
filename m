Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1CFXpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 18:45:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54997 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab1CFXpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 18:45:05 -0500
Message-ID: <4D741C46.70702@zytor.com>
Date: Sun, 06 Mar 2011 15:44:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] mm/memblock: Properly handle overlaps and fix error path
References: <1299453678.8833.969.camel@pasglop> <4D741890.7000607@kernel.org>
In-Reply-To: <4D741890.7000607@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 03:28 PM, Yinghai Lu wrote:
>>  
>> -	rgnbegin = rgnend = 0; /* supress gcc warnings */
>> -From 1f75ea7782bd83f6402964d3b9889ccd69484e02 Mon Sep 17 00:00:00 2001
>> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Date: Mon, 7 Mar 2011 10:18:38 +1100
>> Subject: 
> 
> you put two patches in one mail?
> 

And you quoted the entire email, including both patches, in its entirety
to say that?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

