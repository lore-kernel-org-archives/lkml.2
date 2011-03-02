Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab1CBVQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:16:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23070 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1CBVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:16:39 -0500
Message-ID: <4D6EB335.8000306@kernel.org>
Date: Wed, 02 Mar 2011 13:14:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table handling
References: <20110302102530.GB3319@htj.dyndns.org> <4D6E6D52.8030901@kernel.org> <20110302163729.GQ3319@htj.dyndns.org> <4D6E7459.6050706@kernel.org> <20110302165545.GR3319@htj.dyndns.org> <4D6E91EC.6040906@kernel.org> <20110302190208.GD28266@mtj.dyndns.org> <4D6E9541.2040201@kernel.org> <20110302191338.GE28266@mtj.dyndns.org> <4D6EA975.8070200@kernel.org> <20110302205704.GF28266@mtj.dyndns.org>
In-Reply-To: <20110302205704.GF28266@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D6EB3A1.00B9,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 12:57 PM, Tejun Heo wrote:
> On Wed, Mar 02, 2011 at 12:32:53PM -0800, Yinghai Lu wrote:
>> why use enabled nodes?
>>
>> numa_alloc_distance already have calculated. with numa_nodes_parsed and numa_meminfo
> 
> Because it's simpler that way.
> 
what do you mean "enabled nodes"? numa_nodes_parsed? or from new numa_meminfo?




