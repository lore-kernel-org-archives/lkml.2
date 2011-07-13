Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965219Ab1GMKGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:06:13 -0400
Received: from mail.wdtv.com ([66.118.69.84]:56905 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758673Ab1GMKGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:06:12 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RESEND ibmmca: trivial typo fixes
Date: Wed, 13 Jul 2011 06:06:09 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-pclos2.pae.bfs; KDE/4.6.5; i686; ; )
References: <1310530933.4444.8.camel@offbook> <1310532384.1662.2.camel@Joe-Laptop>
In-Reply-To: <1310532384.1662.2.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107130606.09875.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 13, 2011, Joe Perches wrote:
>On Wed, 2011-07-13 at 00:22 -0400, Davidlohr Bueso wrote:
>> From: Davidlohr Bueso <dave@gnu.org>
>> diff --git a/Documentation/scsi/ibmmca.txt
>> b/Documentation/scsi/ibmmca.txt
>
>[]
>
>> @@ -487,7 +487,7 @@
>> 
>>     1) Submitting the extra-array ldn_is_tape[] -> to the local ld[]
>>     
>>        device-array.
>>     
>>     2) CD-ROM Audio-Play seems to work now.
>> 
>> -   3) When using DDS-2 (120M) DAT-Tapes, mtst shows still density-code
>> +   3) When using DDS-2 (120M) DAT-Tapes, must show still density-code
>
>I think the original is correct.
>mtst is a utility.
>
The original is  correct, I was a former user of several hundred DDS-2 
tapes.

Cheers, gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
No, his mind is not for rent
To any god or government.
Always hopeful, yet discontent,
He knows changes aren't permanent -
But change is.
