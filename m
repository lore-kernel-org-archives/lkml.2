Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893Ab0EZX2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:28:45 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:37237 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934870Ab0EZX2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=T4wfcCogqaVRVoF7fb2I6Oa+QTR8p/aU9ueYNYb507WF1w8oo7xDMatyYXCyaOw5uw
         YoGBJWJO/5pDCjy+XTD2CVjqXBRJb+T3IdWXBhpdcSXFdt2dDio6VWuendT8MO+Zh1gU
         boFk/921IP1qUW3woTtHNeFKgc+NvMNAkPzBA=
Message-ID: <4BFDAEBA.6090805@gmail.com>
Date: Wed, 26 May 2010 16:28:58 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: ath9k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       mcgrog@gmail.com
Subject: Re: [ath9k-devel] [PATCH]wireless:ath9k Fix ath_print in xmit.c
References: <1274892555-10422-1-git-send-email-justinmattock@gmail.com> <20100526230632.2808.qmail@stuge.se>
In-Reply-To: <20100526230632.2808.qmail@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 04:06 PM, Peter Stuge wrote:
> Justin P. Mattock wrote:
>    
>> ath_print in xmit.c should say "Reseting hardware"
>>      
> I think that should be "Resetting hardware" with two t:s.
>
>
> //Peter
>
>    
yep!!
here is the updated version..
http://thread.gmane.org/gmane.linux.kernel.wireless.general
(duh!! I didn't even think  about that)

Thanks for the response.

Justin P. Mattock

