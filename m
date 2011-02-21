Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1BURLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:11:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25961 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1BURLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:11:34 -0500
Message-ID: <4D629C98.4030501@kernel.org>
Date: Mon, 21 Feb 2011 09:10:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH UPDATED 2/3 tip:x86/mm] x86-64, NUMA: Move NUMA emulation
 into numa_emulation.c
References: <20110218135836.GG21209@htj.dyndns.org> <20110218135939.GH21209@htj.dyndns.org> <20110221082657.GA31267@htj.dyndns.org>
In-Reply-To: <20110221082657.GA31267@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D629CB1.0214,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 12:26 AM, Tejun Heo wrote:
> Create numa_emulation.c and move all NUMA emulation code there.  The
> definitions of struct numa_memblk and numa_meminfo are moved to
> numa_64.h.  Also, numa_remove_memblk_from(), numa_cleanup_meminfo(),
> numa_reset_distance() along with numa_emulation() are made global.
> 
> - v2: Internal declarations moved to numa_internal.h as suggested by
>       Yinghai.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
> Yinghai, does it look okay to you?
> 

Yes.

Acked-by: Yinghai Lu <yinghai@kernel.org>
