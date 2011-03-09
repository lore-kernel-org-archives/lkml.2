Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab1CIMui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:50:38 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:18551 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932349Ab1CIMuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:50:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EANQGd01MCqtF/2dsb2JhbACELaI/dbFyPIdiL4hggSeDSHYEhSKHGIZkggM
X-IronPort-AV: E=Sophos;i="4.62,290,1297054800"; 
   d="scan'208";a="95255793"
Message-ID: <4D777796.9030608@gmail.com>
Date: Wed, 09 Mar 2011 07:50:30 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Iceape/2.0.11
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Slaby <jslaby@suse.cz>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: eeepc: rfkill on 900A defunct
References: <4CED26EF.5000109@suse.cz>	<20101124201834.GA7760@srcf.ucam.org>	<4D6B6F9A.1020102@gmail.com>	<4D75FF8E.9010103@gmail.com> <AANLkTinBRCdOa1QdvWJiihvBpmJyvmRvDoFYgp0yTMFc@mail.gmail.com> <4D760A36.5040206@gmail.com>
In-Reply-To: <4D760A36.5040206@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 03/08/2011 11:22 AM, Corentin Chary wrote:
>    
>> On Tue, Mar 8, 2011 at 10:06 AM, Jiri Slaby<jirislaby@gmail.com>  wrote:
>>      
>>> On 02/28/2011 10:49 AM, Jiri Slaby wrote:
>>>        
>>>> On 11/24/2010 09:18 PM, Matthew Garrett wrote:
>>>>          
>>>>> Hm. As a shorter term fix, can you try this (entirely untested!)
>>>>> approach?
>>>>>            
>>>> What is the status of this? Was there any alternative merged?
>>>>          
>>> Ping.
>>>        
>> Because this is Matthew's patch, and I have no hardware to test that
>> patch, I'm not touching it.
>>
>> Jiri, on what models was this patch tested (only got 701 and 901 here) ?
>>      
> It was 900A.
>
> thanks,
>    
I have tested it on 900A and it does the trick.
wlan can now be turned off/on (did not notice the problem before Jiri 
posted the patch ;-) ). So it should go in...

Woody

