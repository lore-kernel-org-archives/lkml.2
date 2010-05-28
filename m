Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab0E1Nby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:31:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab0E1Nbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:31:50 -0400
Message-ID: <4BFFC5A0.5030302@redhat.com>
Date: Fri, 28 May 2010 15:31:12 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Yang, Bo" <Bo.Yang@lsi.com>
CC: James Bottomley <James.Bottomley@suse.de>,
       "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
       "'akpm@osdl.org'" <akpm@osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
Subject: Re: [PATCH 6/7] scsi: megaraid_sas - Add three times Online controller
 reset - V2
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>	 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C3CDB80C32@cosmail02.lsi.com>	 <4BFBF814.5040202@redhat.com> <1274808736.5300.133.camel@mulgrave.site> <4BFD42B4.90207@redhat.com> <4B6A08C587958942AA3002690DD4F8C3D06ADE3F@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D06ADE3F@cosmail02.lsi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 11:08 PM, Yang, Bo wrote:
> Tomas/James,
>
>   
>> Also descriptive subjects would be nice (parts I-III may do well for
>> Lord of the Rings ... it's less useful for SCSI patches).
>>   
>> This is again a question for the original author. Bo?
>>     
> I changed the description and resubmit them already.
>   
Thanks Bo. I've noticed 
[PATCH 1/7] scsi: megaraid_sas - Online Controller Reset - I: Change the Chips related functions and Add the Chip reset functions
[PATCH 2/7] scsi: megaraid_sas - Online controller Reset Support (OCR)-II : Driver return RESET in timeout routine

do you want for the part III to stay with the subject 'Online controller Reset'?


What is more important for me is that in Patch 1/7 you still have spaces instead 
of tabs and the patch can't be applied. The same for patch 3/7. 
You can see the spaces for example here http://www.spinics.net/lists/linux-scsi/msg43842.html

Tomas


> Bo Yang
>
>
>
> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com] 
> Sent: Wednesday, May 26, 2010 11:48 AM
> To: James Bottomley
> Cc: Yang, Bo; 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'; Daftardar, Jayant
> Subject: Re: [PATCH 6/7] scsi: megaraid_sas - Add three times Online controller reset - V2
>
> On 05/25/2010 07:32 PM, James Bottomley wrote:
>   
>> On Tue, 2010-05-25 at 18:17 +0200, Tomas Henzl wrote:
>>   
>>     
>>> V2: I've cleaned up some coding style issues and removed a variable, the functionality shouldn't be changed
>>>
>>> Tomas
>>>
>>> If fw didn't raise the interrupt with the fw state change to driver and fw goes to failure state, driver
>>> Will check the FW state in driver's timeout routine and issue the reset if need.  Driver will do the OCR upto three
>>> Times until kill adapter.  Also driver will issue OCR before driver kill adapter even if fw in operational state.   
>>>     
>>>       
>> So there's supposed to be a replacement for 3/7 (megaraid_sas - Online
>> COntroller Reset (OCR) PART-III) as well, isn't there?
>>   
>>     
> Yes, I think there are some issues that could be removed, on the other side
> it is mostly coding style related, so I think it could be accepted as it is.
> I hope I could afterwards clean something up. (The patches as they are now don't
> apply correctly on my system, it's maybe an issue with my mail reader.)
>  
>
>   
>> Also descriptive subjects would be nice (parts I-III may do well for
>> Lord of the Rings ... it's less useful for SCSI patches).
>>   
>>     
> This is again a question for the original author. Bo?
>
> Tomas
>
>
>   
>> James
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   
>>     
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���"�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��!tml=

