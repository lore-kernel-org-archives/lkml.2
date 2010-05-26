Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0EZVJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:09:06 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:58662 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755413Ab0EZVJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:09:01 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: Tomas Henzl <thenzl@redhat.com>, James Bottomley <James.Bottomley@suse.de>
CC: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
       "'akpm@osdl.org'" <akpm@osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
Date: Wed, 26 May 2010 15:08:48 -0600
Subject: RE: [PATCH 6/7] scsi: megaraid_sas - Add three times Online
 controller reset - V2
Thread-Topic: [PATCH 6/7] scsi: megaraid_sas - Add three times Online
 controller reset - V2
Thread-Index: Acr8690Xcf+MChxYQoChSacgSDEEkQAK29JA
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D06ADE3F@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
	 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C3CDB80C32@cosmail02.lsi.com>
	 <4BFBF814.5040202@redhat.com> <1274808736.5300.133.camel@mulgrave.site>
 <4BFD42B4.90207@redhat.com>
In-Reply-To: <4BFD42B4.90207@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4QLAwim010568

Tomas/James,

> Also descriptive subjects would be nice (parts I-III may do well for
> Lord of the Rings ... it's less useful for SCSI patches).
>   
>This is again a question for the original author. Bo?

I changed the description and resubmit them already.

Bo Yang



-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Wednesday, May 26, 2010 11:48 AM
To: James Bottomley
Cc: Yang, Bo; 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'; Daftardar, Jayant
Subject: Re: [PATCH 6/7] scsi: megaraid_sas - Add three times Online controller reset - V2

On 05/25/2010 07:32 PM, James Bottomley wrote:
> On Tue, 2010-05-25 at 18:17 +0200, Tomas Henzl wrote:
>   
>> V2: I've cleaned up some coding style issues and removed a variable, the functionality shouldn't be changed
>>
>> Tomas
>>
>> If fw didn't raise the interrupt with the fw state change to driver and fw goes to failure state, driver
>> Will check the FW state in driver's timeout routine and issue the reset if need.  Driver will do the OCR upto three
>> Times until kill adapter.  Also driver will issue OCR before driver kill adapter even if fw in operational state.   
>>     
> So there's supposed to be a replacement for 3/7 (megaraid_sas - Online
> COntroller Reset (OCR) PART-III) as well, isn't there?
>   
Yes, I think there are some issues that could be removed, on the other side
it is mostly coding style related, so I think it could be accepted as it is.
I hope I could afterwards clean something up. (The patches as they are now don't
apply correctly on my system, it's maybe an issue with my mail reader.)
 

> Also descriptive subjects would be nice (parts I-III may do well for
> Lord of the Rings ... it's less useful for SCSI patches).
>   
This is again a question for the original author. Bo?

Tomas


> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
