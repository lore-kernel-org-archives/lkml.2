Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1BXTkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:40:06 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45746 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab1BXTkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:40:02 -0500
Message-ID: <4D66B3A5.1050706@kernel.org>
Date: Thu, 24 Feb 2011 11:38:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/3 tip:x86/mm] x86-64, NUMA: Move NUMA emulation into
 numa_emulation.c
References: <20110218135836.GG21209@htj.dyndns.org> <20110218135939.GH21209@htj.dyndns.org> <4D5EB35D.3000305@kernel.org> <alpine.DEB.2.00.1102201357110.26991@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1102201357110.26991@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D66B3F8.0037,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2011 01:58 PM, David Rientjes wrote:
> On Fri, 18 Feb 2011, Yinghai Lu wrote:
> 
>> David, can you please check tip/x86/mm ?
>>
> 
> Yeah, I'm in the process of doing so without this set yet.  I'm getting 
> boot failures for numa=fake=128M right now, so I'll need to investigate 
> and diagnose that issue before adding more patches.


any info about the boot failures?

Thanks

Yinghai
