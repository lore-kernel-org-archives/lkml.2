Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2H2Cra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 22:47:30 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35812 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2H2Cr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 22:47:29 -0400
Message-ID: <503D825B.6050506@linux.vnet.ibm.com>
Date: Wed, 29 Aug 2012 08:15:47 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, prasad.krishnan@gmail.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, emachado@linux.vnet.ibm.com
Subject: Re: [PATCH v3] Hardware breakpoints: Invoke __perf_event_disable()
 if interrupts are already disabled
References: <20120731134124.GD17078@somewhere.redhat.com> <20120802081635.5811.17737.stgit@localhost.localdomain> <502BDE3D.6070909@linux.vnet.ibm.com> <20120815184216.GC19716@somewhere> <1345105019.29668.0.camel@twins>
In-Reply-To: <1345105019.29668.0.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082902-9574-0000-0000-0000042EA99C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 01:46 PM, Peter Zijlstra wrote:
> On Wed, 2012-08-15 at 20:42 +0200, Frederic Weisbecker wrote:
>> On Wed, Aug 15, 2012 at 11:07:01PM +0530, Naveen N. Rao wrote:
>>> Hi Frederick,
>>> Did you get a chance to take a look at this?
>>>
>>> Regards,
>>> Naveen
>>
>> Yeah, I'm ok with the patch. Peter, are you ok with it?
>
> Yeah, queued, it. sorry for loosing track etc..
>

Hi Peter,
Can you please let me know if you plan to push this for v3.6 or if this 
has been queued for the next kernel release?

Thanks,
Naveen

