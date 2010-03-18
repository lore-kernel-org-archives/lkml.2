Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0CRILs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:11:48 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:43595 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0CRILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:11:46 -0400
X-SENDER-IP: [83.226.250.86]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUsALB9oUtT4vpWPGdsb2JhbACBPYYjk1YBAQEBN7d1hHgE
X-IronPort-AV: E=Sophos;i="4.51,265,1267398000"; 
   d="scan'208";a="52396903"
Message-ID: <4BA1E03D.4050602@coyote.org>
Date: Thu, 18 Mar 2010 09:11:41 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mds_f.h whitespace corrections.
References: <1268899193-16034-1-git-send-email-lindley@coyote.org> <4BA1DE50.1080908@cs.helsinki.fi>
In-Reply-To: <4BA1DE50.1080908@cs.helsinki.fi>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure..So Mds_SendComplete would be mds_send_complete?

/Lars

On 2010-03-18 09:03, Pekka Enberg wrote:
> Lars Lindley kirjoitti:
>> I fixed the whitespaces and the C99 comment.
>>
>> Signed-off-by: Lars Lindley <lindley@coyote.org>
>> ---
>>  drivers/staging/winbond/mds_f.h |   20 ++++++++++----------
>>  1 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/staging/winbond/mds_f.h
>> b/drivers/staging/winbond/mds_f.h
>> index e09dd4b..0d2bccf 100644
>> --- a/drivers/staging/winbond/mds_f.h
>> +++ b/drivers/staging/winbond/mds_f.h
>> @@ -4,17 +4,17 @@
>>  #include "wbhal_s.h"
>>  #include "core.h"
>>  
>> -unsigned char Mds_initial(  struct wbsoft_priv *adapter );
>> -void Mds_Destroy(  struct wbsoft_priv *adapter );
>> -void Mds_Tx(  struct wbsoft_priv *adapter );
>> -void Mds_SendComplete(  struct wbsoft_priv *adapter,  PT02_DESCRIPTOR
>> pT02 );
>> -void Mds_MpduProcess(  struct wbsoft_priv *adapter,  struct
>> wb35_descriptor *pRxDes );
>> +unsigned char Mds_initial(struct wbsoft_priv *adapter);
>> +void Mds_Destroy(struct wbsoft_priv *adapter);
>> +void Mds_Tx(struct wbsoft_priv *adapter);
>> +void Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR
>> pT02);
>> +void Mds_MpduProcess(struct wbsoft_priv *adapter, struct
>> wb35_descriptor *pRxDes);
>>  extern void DataDmp(u8 *pdata, u32 len, u32 offset);
>>  
>> -// For data frame sending 20060802
>> -u16 MDS_GetPacketSize(  struct wbsoft_priv *adapter );
>> -void MDS_GetNextPacket(  struct wbsoft_priv *adapter,  struct
>> wb35_descriptor *pDes );
>> -void MDS_GetNextPacketComplete(  struct wbsoft_priv *adapter,  struct
>> wb35_descriptor *pDes );
>> -void MDS_SendResult(  struct wbsoft_priv *adapter,  u8 PacketId, 
>> unsigned char SendOK );
>> +/* For data frame sending */
>> +u16 MDS_GetPacketSize(struct wbsoft_priv *adapter);
>> +void MDS_GetNextPacket(struct wbsoft_priv *adapter, struct
>> wb35_descriptor *pDes);
>> +void MDS_GetNextPacketComplete(struct wbsoft_priv *adapter, struct
>> wb35_descriptor *pDes);
>> +void MDS_SendResult(struct wbsoft_priv *adapter, u8 PacketId,
>> unsigned char SendOK);
> 
> While you're at it, how about fixing up those CamelCase parameter names
> as well?
> 
>             Pekka
> 
