Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab1CKPs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:48:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:43165 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1CKPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:48:22 -0500
Message-ID: <4D7A4430.1030301@kernel.org>
Date: Fri, 11 Mar 2011 07:48:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table handling
References: <4D6E91EC.6040906@kernel.org> <20110302190208.GD28266@mtj.dyndns.org> <4D6E9541.2040201@kernel.org> <20110302191338.GE28266@mtj.dyndns.org> <4D6EA975.8070200@kernel.org> <20110302205704.GF28266@mtj.dyndns.org> <4D6EB335.8000306@kernel.org> <20110303061711.GG28266@mtj.dyndns.org> <4D791C9F.1010500@kernel.org> <20110311082938.GC13038@htj.dyndns.org> <20110311083351.GD13038@htj.dyndns.org>
In-Reply-To: <20110311083351.GD13038@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D7A4439.01D2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 12:33 AM, Tejun Heo wrote:
> On Fri, Mar 11, 2011 at 09:29:38AM +0100, Tejun Heo wrote:
>> Also, I don't think your patch is correct.  Even if there is phys_dist
>                                                               ^
> 							      no
>> table, emu distance tables should be built because emulated nids don't
>> map to physical nids one to one.  ie. Two different emulated nids can
>> share a physical node and the distance table should explicitly reflect
>> that.

ok, when original SLIT is not there, mean only one really node.
so the new distance table should be filled with LOCAL_DISTANCE.

Yinghai

