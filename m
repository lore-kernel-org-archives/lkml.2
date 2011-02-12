Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1BLSPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 13:15:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:54639 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1BLSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 13:15:09 -0500
Message-ID: <4D56CDDF.8050401@kernel.org>
Date: Sat, 12 Feb 2011 10:13:51 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 02/26] x86-64, NUMA: Simplify hotplug node handling in
 acpi_numa_memory_affinity_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org>	<1297530663-26234-3-git-send-email-tj@kernel.org>	<4D56C79B.2060201@kernel.org>	<AANLkTimiKA91OEMyt-KM5q5V5s6-xS_76Ji-Y8M_k4Bt@mail.gmail.com>	<4D56CB9F.8030909@kernel.org> <AANLkTimAceZOxWQq03QqhXhQ42r2jw6MQYA9Vc2XQo5B@mail.gmail.com>
In-Reply-To: <AANLkTimAceZOxWQq03QqhXhQ42r2jw6MQYA9Vc2XQo5B@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2011 10:06 AM, Tejun Heo wrote:
> On Sat, Feb 12, 2011 at 7:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> no. if the node only have hotplug mem.
>> then nd->start and nd->end will be set to that hot plug range.
>> and old code does not clear nodes_parsed...
> 
> Eh?  The oldnode thing will restore the node to initial state thus
> fulfilling the node empty condition.  Am I missing something?
> 

yes. nd get restored, but it keep node_parsed set for that kind of node.

Yinghai
