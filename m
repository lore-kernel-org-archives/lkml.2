Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab1D3XKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 19:10:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50837 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1D3XKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 19:10:33 -0400
Message-ID: <4DBC96D0.5010004@kernel.org>
Date: Sat, 30 Apr 2011 16:10:08 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/25] x86, NUMA: trivial cleanups
References: <1304090924-8197-1-git-send-email-tj@kernel.org>	<1304090924-8197-9-git-send-email-tj@kernel.org>	<4DBAF498.40007@kernel.org>	<20110430120307.GE29280@htj.dyndns.org>	<4DBC37D0.3070408@kernel.org> <BANLkTimaDnFZbSAitJOPdKb2fuuHKS0HpQ@mail.gmail.com>
In-Reply-To: <BANLkTimaDnFZbSAitJOPdKb2fuuHKS0HpQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DBC96DA.00AD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2011 11:00 AM, Tejun Heo wrote:
> Hello,
> 
> On Sat, Apr 30, 2011 at 6:24 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> I posted two patches for
>> Kill no longer used struct bootnode.
>> Make setup_node_bootmem() static
> 
> Ah, okay.  Do you mind resending them to me?  I'll integrate it with
> the patchset.

Never mind. Do not want to waste your time to rebase your tree.

> 
>> Also setup_node_bootmem now is some misleading, could change to setup_node_data() ?
> 
> Sure, I don't like the current name either.  Do you mind sending a
> patch for that too?

ok, another mail.

Thanks

Yinghai Lu
