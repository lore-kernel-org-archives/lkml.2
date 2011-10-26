Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1JZHBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:01:40 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:54608 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1JZHBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:01:38 -0400
Message-ID: <4EA7B044.5030200@scalemp.com>
Date: Wed, 26 Oct 2011 09:01:24 +0200
From: Eial Czerwacki <eial@scalemp.com>
Organization: ScaleMP
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101020 Remi/fc8 Thunderbird/3.1.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH] APICID: Avoid false sharing on the read mostly x86_cpu_to_apicid
References: <4EA66960.7050907@scalemp.com> <9B14D1490DDECA4E974F6B9FC9EBAB3140CD274367@VMBX108.ihostexchange.net> <4EA6A265.1080506@scalemp.com> <alpine.DEB.2.00.1110252318090.20273@chino.kir.corp.google.com> <4EA7AB7C.9080703@scalemp.com> <alpine.DEB.2.00.1110252345260.20273@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110252345260.20273@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 08:47 AM, David Rientjes wrote:

> On Wed, 26 Oct 2011, Eial Czerwacki wrote:
> 
>>>> Signed-off-by: Eial Czerwacki<eial@scalemp.com>
>>>> Signed-off-by: Shai Fultheim<shai@scalemp.com>
>>>> Author: Ravikiran Thirumalai<kiran@scalex86.org>
>>>
>>> If the author isn't you, then the patch should start with a single line 
>>> that says "From: name <email>" of the author followed by a blank line.  
>>> It's also strange that the author doesn't have a sign-off line.
>>>
>>
>>
>> the author is mentioned after the last sign-off.
>>
> 
> That's not the way it's done, as I said, the patch needs to start with a 
> single line like this:
> 
> From: Ravikiran Thirumalai <kiran@scalex86.org>
> 
> ...
> 
> and if that person signed it off, then it needs to appear as
> 
> Signed-off-by: ...
> 
> as the first one in the chain.  Please see part 15 of section 1 of 
> Documentation/SubmittingPatches.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


sure, thanks got the info


Eial.
